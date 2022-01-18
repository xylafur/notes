/* Chapter 2 is over user defined types */

/* Structs */
// a struct is simply a class with all members public by default
struct Vector {
    int sz;
    double *elem;
};

void vector_init(Vector& v, ints s)
{
    v.elem = new double[s];
    v.sz = s;
}

void section_2_2() {
    Vector v;
    vector_init(v, 5);

    Vector *ptr = &v;
    v->sz = 5;
}

/* Classes*/
class Vector {
public:
    Vector(int s): elem{new double[s]}, sz{s}{}

    // double& means it accepts both reads and writes
    double& operator[](int i) { return elem[i]; }
    int size() { return sz; }
private:
    double* elem;
    int sz;
}

void section 2_3() {
    int s = 5;
    Vetor v(s);

    for (int i=0; i!=v.size(); ++i) {
        cin >> v[i];
    }

    double sum = 0;
    for (int i=0; i!=v.size(); ++i) {
        sum += v[i];
    }
    return sum;
}

// Section 2.4 - Unions
enum Type {ptr, num};

union Value {
    Node* p;
    int i;
};

struct Entry {
    string name;
    Type t;
    Value v;
};

// he says that using the standard library type 'variant' is usually better
// than union

struct Entry {
    string name;
    variable<Node*, int> v;
}

void func(Entry *pe)
{
    if (holds_alternative<int>(pe->v)) { // does this entry hold an int?
        cout << get<int>(pe->v);
    }
}

// Section 2.5 - Enumerations
enum class Color {red, blue, green};

Color col = Color::red;

// the class after enum specifies that this enum is strongly typed, meaning we
// need the `Color::` at the beginning

Color y {6}; // valid
Color x = 6; // invalid

// Because an enum class is a user defined type, we can define operators for it
enum class Traffic_Light {green, yellow, red};

Traffic_Light& operator++(Traffic_light& t)
{
    switch(t) {
        case Traffic_Light::green:      return t=Traffic_light::yellow;
        case Traffic_Light::yellow:     return t=Traffic_light::red;
        case Traffic_Light::red:        return t=Traffic_light::green;
    }
}


Traffic_Light start = Traffic_Light::green;
Traffic_Light next = ++light;

// You can use C style enums if you omit the "class" keyword
