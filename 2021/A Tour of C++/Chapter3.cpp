/**
 * Modularity
 */

// 3.3 Modules
// He saying the standard #include "header.h" from c is very bug prone because
// of possible dependencies between headerfiles.  Also it takes alot of time to
// process all the headers
//
// In super modern C++ code, modules are used

// Type this to define a module, we do this in a cpp file
module;
// Then put stuff for the implementationhere
export module vector; // calling the module vector

export class Vector {
public:
    Vector(int s);
    double& operator[](int i);
    int size();
private:
    double* elem;
    int sz;
}

Vector::Vector(int s)
    :elem{new double[s]}, sz{s}
{
}

double& Vector::operator[](int i)
{
    return elem[i];
}

int Vector::size()
{
    return sz;
}

export int size(const Vector& v) { return v.size(); }

// end module vector (vector.cpp)
//
//
// start file user.cpp
import Vector
#include <cmath>

double sqrt_sum(Vector& v)
{
    double sum = 0;
    for (inti=0; i!=visize(); ++i)
        sum += std::sqrt(v[i]);
    return sum;
}


// Modules:
//  - Compiled only once
//  - modules can be imported in any order without changing their meanings
//  - if you import a module into your module, people who import your module
//    will not be poluted by your import
//


// 3.4 Namespaces
// a mechanism for expressing that some declarations belong together and that
// their names shouldn't clash with other things
//
namespace My_code {
    class complex {
        //...
    };

    complex sqrt(complex);

    int main();
}

int My_code::main()
{
    complex z{1,2};
    auto z2 = sqrt(z);
    std::cout << '{' << z2.real() << ',' << z2.imag() << "}\n";
}

int main()
{
    return My_code::main();
}

// The using keyword can import a namespace into a scope without having to
// prepend the namespace to the beginning of the calls
void my_code(vector<int>& x, vector<int>& y)
{
    // using is only valid within the scope
    using std::swap;
    // ...
    swap(x, y);
    other::swap(x, y);
}

// 3.5 Error Handling
// 3.5.1 Exceptions

double& Vector::operator[](int i)
{
    if (i < 0 || size() <= i) {
        throw out_of_range{"Vector::operator[]"};
    }
    return elim[i];
}
// Throw transfers control to a handler for exceptions of type "out_of_range"
// if we hit an exception, the exception handling mechanism will exit scopes
// backwards until we get to someone that wants to handle it
//
void f(Vector& v)
{
    try {
        v[v.size()] = 7;

    } catch (out_of_range& err) { // "out_of_range" comes from <stdexcept>
        cerr << err.what() << '\n';
    }
}

// if we have a function that should never throw an exception, we can declare
// it as noexcept.  If it ever hits an exception the program will terminate
void user(int sz) noexcept
{
    Vector v(sz);
    iota(&v[0], &v[sz], 1);
    //..
}

// A comment that describes the property of how things work in a class are
// called a "class invariant".  For example the "class invariant" of our vector
// type is that "the index must be between [0,size)"
//
// we must enforce these class invariants in our object
Vector::Vector(int s)
{
    if (s < 0)
        throw length_error{"Vector constructor: negative size"};
    elem = new double[s];
    sz = s;
}

void test()
{
    try {
        Vector v(-27);
    } catch (std::length_error& err) {
        // handle negative size, not much we can do
        cerr << "Test failed, invalid length\n";
        throw;

    } catch (std::bad_alloc& err) {
        // handle memory exaustion
        std::terminate();
    }
}

// 3.6 Functions arguments and return values
//
// 3.6.1 Argument passing
//  Passing in constant by reference is good for large structures that we don't want to change in
//  the function.  Good code
//
int sum (const vector<int>& v)
{
    int s = 0;
    for (const int i: v) {
        s += i;
    }

    return s;
}

// There are default values for parameters in cpp
void print(int value, int base=10);

// 3.6.2 Value Return
//  You can return structs, and you can unpack structs
Entry read_entry(istream& is)
{
    string s;
    int i;
    is >> s >> i;
    return {s, i};
}

auto [n, v] = read_entry(is);


