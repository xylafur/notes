#include <stdint.h>
#include <stdio.h>
#include <unistd.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

/******************************************************************************
 *  Image type header
******************************************************************************/
struct pixel {
    union {
        struct {
            unsigned char r;
            unsigned char g;
            unsigned char b;
        };
        uint32_t raw;
    };
};

struct image {
    uint64_t width, height;
    struct pixel** data;
};

/******************************************************************************
 *  Error handling library
******************************************************************************/
#define READ_STATUS(ST) READ_STATUS_ ## ST
#define READ_STATUSES()             \
    READ_STATUS(OK),                \
    READ_STATUS(FILE_DOESNT_EXIST), \
    READ_STATUS(FOPEN),             \
    READ_STATUS(FCLOSE),            \
    READ_STATUS(INVALID_FILETYPE),  \
    READ_STATUS(INVALID_HEADER)

enum read_status {
    READ_STATUSES(),

    READ_MAX,
};

#undef READ_STATUS
#define READ_STATUS(ST) #ST
const char * read_status_str [] = {
    READ_STATUSES()
};

enum write_status {
    WRITE_STATUS_OK = 0,
    WRITE_STATUS_ERROR,
    WRITE_STATUS_INVALID_FILETYPE,
    WRITE_STATUS_FOPEN,
    WRITE_STATUS_FCLOSE,

    WRITE_MAX,
};

enum operation_status {
    OP_STATUS_OK = 0,
    OP_STATUS_READ_FAILED,
    OP_INVALID_OP,
    OP_STATUS_WRITE_FAILED,

    OP_STATUS_MAX,
};


void log_read_error(enum read_status rst)
{
    // This function is written like this so that eventually it could take in a second argument for
    // "program type", ie CLI or GUI or something like that.  Doing this makes support modular, so
    // eventually the front end of this program theoretically could be expanded to more than a
    // simple CLI tool
    printf("Read error: %s (%d)\n", read_status_str[rst], rst);
}

void log_op_error(enum operation_status ost)
{
    printf("Op error: %d\n", ost);
}

void log_write_error(enum write_status wst)
{
    printf("Write error: %d\n", wst);
}

void log_success()
{
    printf("Successfully finished image manip program\n");
}

/******************************************************************************
 *  BMP Library
******************************************************************************/

//#include "image.h"
struct __attribute__((packed)) bmp_file_header {
    /* File Header */
    uint16_t bfType;
    uint32_t bfileSize;
    uint32_t bfReserved;
    uint32_t bOffBits;
};

struct __attribute__((packed)) bmp_image_header {
    /* Image Header */
    uint32_t biSize; /* Header size */
    uint32_t biWidth;
    uint32_t biHeight;
    uint16_t biPlanes;
    uint16_t biBitCount;
    uint32_t biCompression;
    uint32_t biSizeImage;
    uint32_t biXPelsPerMeter;
    uint32_t biYPelsPerMeter;
    uint32_t biClrUsed;
    uint32_t biClrImportant;
};

struct __attribute__((packed)) bmp_header {
    struct bmp_file_header file_header;
    struct bmp_image_header image_header;
};


void bmp_dump_header(struct bmp_header *header)
{
    printf("File header\n");
    printf("  header->bfType:         %u\n", header->file_header.bfType);
    printf("  header->bfileSize:      %u\n", header->file_header.bfileSize);
    printf("  header->bfReserved:     %u\n", header->file_header.bfReserved);
    printf("  header->bOffBits:       %u\n", header->file_header.bOffBits);
    printf("Image Header\n");
    printf("  header->biSize:         %u\n", header->image_header.biSize);
    printf("  header->biWidth:        %u\n", header->image_header.biWidth);
    printf("  header->biHeight:       %u\n", header->image_header.biHeight);
    printf("  header->biPlanes:       %u\n", header->image_header.biPlanes);
    printf("  header->biBitCount:     %u\n", header->image_header.biBitCount);
    printf("  header->biCompression:  %u\n", header->image_header.biCompression);
    printf("  header->biSizeImage:    %u\n", header->image_header.biSizeImage);
    printf("  header->biXPelsPerMeter:%u\n", header->image_header.biXPelsPerMeter);
    printf("  header->biYPelsPerMeter:%u\n", header->image_header.biYPelsPerMeter);
    printf("  header->biClrUsed:      %u\n", header->image_header.biClrUsed);
    printf("  header->biClrImportant: %u\n", header->image_header.biClrImportant);
}

bool bmp_header_valid(struct bmp_header *header)
{
    if (header->file_header.bfType != 0x4d42) {
        /* This is supposed to always be equal to "BM", little endian */
        return false;
    }

    //if (header->biBitCount != 24) {
    //    /* We only support 24 bit images */
    //    return false;
    //}

    //if (header->biCompression != 0) {
    //    /* Should be no compression on 24 bit images */
    //    return false;
    //}
    return true;
}

//uint32_t bmp_get_header_size(struct

uint32_t bmp_get_image_size(struct bmp_header *header)
{
    return header->image_header.biSizeImage;
}

enum read_status read_header(FILE* in, struct bmp_header *header)
{
    fread(header, sizeof(struct bmp_header), 1, in);

    if (!bmp_header_valid(header)) {
        return READ_STATUS_INVALID_HEADER;
    }

    fseek(in, header->image_header.biSize - sizeof(struct bmp_image_header),
          SEEK_CUR);

    return READ_STATUS_OK;
}


enum read_status read_image(FILE* in, uint32_t bit_cnt, uint32_t width, uint32_t height, struct image** read)
{
    uint32_t ii, jj;
    *read = malloc(sizeof(struct image));
    (*read)->data = malloc(sizeof(struct pixel*) * height);
    for (ii = 0; ii < height; ii++) {
        (*read)->data[ii] = malloc(sizeof(struct pixel) * width);
    }

    /* Image starts at bottom left corner */
    for (ii = 0; ii < width; ii++) {
        for (jj = 0; jj < height; jj++) {
            fread(&((*read)->data[height - 1 - jj][ii].raw), bit_cnt / 8, 1, in);
        }
    }

    (*read)->width  = width;
    (*read)->height = height;

    return READ_STATUS_OK;
}

static void dump_image(struct image *read)
{
    uint32_t ii, jj;
    for (ii = 0; ii < read->height; ii++) {
        for (jj = 0; jj < read->width; jj++) {
            printf("0x%02x%02x%02x ", read->data[ii][jj].r, read->data[ii][jj].g, read->data[ii][jj].b);
        }
        printf("\n");
    }
}


enum read_status from_bmp(FILE* in, struct image** read)
{
    struct bmp_header header = {0};
    enum read_status rst;

    rst = read_header(in, &header);
    if (rst != READ_STATUS_OK) {
        return rst;
    }

    bmp_dump_header(&header);


    rst = read_image(in, header.image_header.biBitCount, header.image_header.biWidth, 
                     header.image_header.biHeight, read);
    if (rst != READ_STATUS_OK) {
        return rst;
    }
    if (0) {
        dump_image(*read);
    }

    return READ_STATUS_OK;
}

enum write_status bmp_write_header(FILE* out, struct image const* img)
{
    struct bmp_header header = {0};

    header.file_header.bfType = 0x4d42;
    header.file_header.bfileSize = sizeof(struct bmp_header) + 3 * img->width * img->height;
    header.file_header.bOffBits = sizeof(struct bmp_header);

    header.image_header.biSize = sizeof(struct bmp_image_header);
    header.image_header.biWidth = img->width;
    header.image_header.biHeight = img->height;
    header.image_header.biPlanes = 1;
    header.image_header.biBitCount = 24;
    header.image_header.biSizeImage = 3 * img->width * img->height;

    bmp_dump_header(&header);

    fwrite(&header, sizeof(struct bmp_header), 1, out);

    return WRITE_STATUS_OK;
}
enum write_status bmp_write_image(FILE* out, struct image const* img)
{
    uint32_t ii, jj;
    const uint32_t height = img->height, width = img->width;

    /* Image starts at bottom left corner */
    for (ii = 0; ii < width; ii++) {
        for (jj = 0; jj < height; jj++) {
            fwrite(&(img->data[height-1-jj][ii].raw), 3, 1, out);
        }
    }
    return WRITE_STATUS_OK;
}

enum write_status to_bmp(FILE* out, struct image const* img)
{
    enum write_status wst;

    wst = bmp_write_header(out, img);
    if (wst != WRITE_STATUS_OK) {
        return wst;
    }

    wst = bmp_write_image(out, img);
    if (wst != WRITE_STATUS_OK) {
        return wst;
    }

    return WRITE_STATUS_OK;
}

/******************************************************************************
 *  general image library
******************************************************************************/
//#include "bmp.h"

enum file_type {
    FTP_BMP,

    FTP_MAX,
};

enum operation {
    OP_ROTATE,
    OP_NOOP,

    OP_MAX,
};

enum operation_status rotate(struct image const *source, struct image** dest)
{
    uint32_t ii, jj;
    // TODO: Check null pointers
    *dest = malloc(sizeof(struct image));
    (*dest)->height = source->width;
    (*dest)->width = source->height;

    (*dest)->data = malloc(sizeof(struct pixel*) * source->width);
    for (ii = 0; ii < source->width; ii++) {
        (*dest)->data[ii] = malloc(sizeof(struct pixel) * source->height);
    }

    for (ii = 0; ii < source->height; ii++) {
        for (jj = 0; jj < source->width; jj++) {
            (*dest)->data[jj][ii].raw = source->data[source->height - 1 - ii][jj].raw;
        }
        printf("%u %u\n", ii, jj);
    }

    return OP_STATUS_OK;
}

enum operation_status perform_operation(struct image *input_img, struct image **output_img,
                                        enum operation op)
{
    enum operation_status ost = OP_STATUS_OK;

    switch (op) {
        case OP_ROTATE:
            ost = rotate(input_img, output_img);
            break;
        case OP_NOOP:
            *output_img = input_img;
            break;
        default:
            ost = OP_INVALID_OP;
            break;
    }

    return ost;
}

/******************************************************************************
 *  Main file
******************************************************************************/

enum read_status load_image(const char * in_file, enum file_type ftp, struct image **input_img)
{
    FILE *in;
    enum read_status rst = READ_STATUS_OK;

    if (access(in_file, F_OK)) {
        return READ_STATUS_FILE_DOESNT_EXIST;
    }

    in = fopen(in_file, "rb");
    if (NULL == in) {
        return READ_STATUS_FOPEN;
    }

    switch (ftp) {
        case FTP_BMP:
            rst = from_bmp(in, input_img);
            break;
        default:
            return READ_STATUS_INVALID_FILETYPE;
            break;
    }

    if (rst == READ_STATUS_OK && fclose(in)) {
        return READ_STATUS_FCLOSE;
    }

    return rst;
}

enum write_status save_image(const char * out_file, enum file_type ftp, struct image *img)
{
    enum write_status wst = WRITE_STATUS_OK;
    FILE *out = fopen(out_file, "wb");
    if (NULL == out) {
        return WRITE_STATUS_FOPEN;;
    }

    switch (ftp) {
        case FTP_BMP:
            wst = to_bmp(out, img);
            break;
        default:
            // Should not be possible?
            wst = WRITE_STATUS_INVALID_FILETYPE;
            break;
    }

    if (fclose(out)) {
        return WRITE_STATUS_FCLOSE;
    }

    return wst;
}

void image_prog(const char * in_file, const char * out_file, enum operation op,
                enum file_type in_ftp, enum file_type out_ftp)
{
    struct image *input_img = NULL, *output_img = NULL;
    enum read_status rst;
    enum operation_status ost;
    enum write_status wst;

    rst = load_image(in_file, in_ftp, &input_img);
    if (rst != READ_STATUS_OK) {
        log_read_error(rst);
        return;
    }

    ost = perform_operation(input_img, &output_img, op);
    if (ost != OP_STATUS_OK) {
        log_op_error(ost);
        return;
    }

    wst = save_image(out_file, out_ftp, output_img);
    if (wst != WRITE_STATUS_OK) {
        log_write_error(wst);
        return;
    }

    log_success();
}

int main()
{
    const char * in_file = "input_file.bmp";
    const char * out_file = "output_file.bmp";
    //enum operation op = OP_NOOP;
    enum operation op = OP_ROTATE;
    enum file_type in_ftp = FTP_BMP;
    enum file_type out_ftp = FTP_BMP;
    // getopt(int argc, char * const argv [], const char *optstring);

    image_prog(in_file, out_file, op, in_ftp, out_ftp);

    return 0;
}
