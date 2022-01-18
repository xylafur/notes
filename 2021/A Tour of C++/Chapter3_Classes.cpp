//4.1 Intro


// 4.2 Concrete types
//   These concrete classes are supposed to behave just like build in types
//
//   The defining characteristic of a concrete type is that its representation is part of its
//   definition
//      This allows us to
//          - put concrete objects on the stack
//          - refer to the objects directly (not through pointers)
//          - Init objects immediately and completely
//
//      These concrete types can have part of its representation in dynamic memory, as long as the
//      pointers or references to that memory exist in the class object itself
//
//  4.2.1 An arithmetic Type
class complex {
    double re, im;
public:
    complex(double r, double i) :re{r}, im{i} {}
    complex(double r) :re{r}, im{0} {}
    complex() :re{0}, im{0} {}

    double real() const {return re;}
    void real(double d) {re=d};

    double imag() const {return im};
    void imag(double d) {im = d};

    complex & operator += (complex z)
    {
        re += z.re;
        im += z.im;
        return *this;
    }

    complex & operator -= (complex z)
    {
        re -= z.re;
        im -= z.im;
        return *this;
    }

    complex& operator *=(complex);
    complex& operator /=(complex);
};

// we want to implement common operations without any function calls so that they can be efficient
// in the generated machine code.
//
// Functions defined in a class are inlined by default
//

//
// 4.2.2 A Container



