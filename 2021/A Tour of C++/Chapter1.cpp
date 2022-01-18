/*
 * 1.4 Types, Variables and Arithmetic
 *  - A type defines a set of possible values and a set of operators
 *  - An object is some memory that holds a value of some type
 *  - a value is a set of bits interpreted according to a type
 *  - a variable is a named object
 *
 */

#include <iostream>

using namespace std;

// section 1.4
void section_1_4_2() {
    // you can use {} for any initilizer
    double d1 {2.4};
    int i2 {4};

    //This is also valid, but not encouraged as much as the above
    int i3 = {5};

    // when the type can be deduced you can use auto
    auto b = true;
    auto ch = 'x';

    auto bb {true};
}

//1.6 Constants
int from_fucntion() { return 5; }

constexpr double square(double x) { return x*x; }

void section_1_6() {
    //const variables can be specified at runtime
    const int x {from_function()};

    // constexpr must be known at compile time
    constexpr double pi {3.14};

    // This is valid when the function specifies it returns a constexpr
    constexpr double x2 = square(5.5);

    // constexpr functions cannot have side effects, very similar to lambdas
}

//1.7 Pointers, Arrays and References
void range_for_statement() {
    int v[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};

    for (auto x : v) {
        cout << x << '\n';
    }

    for (auto x : {10, 21, 32, 43, 54, 65}) {
            cout << x << '\n';
    }

    // you can also have the variable in the range-for-statement access by
    // reference (to edit from the array)
    for (auto &x : v) {
        ++x;
    }
}

// functions that use const references can be very efficient.  YOu can't edit
// the const but it still takes it in by reference instead of value
double sum(const vector<double>& v);

// the null pointer
void section_1_7_1() {
    double* pd = nullptr;
}


// 1.8 - Tests
bool accept()
{
    cout << "Do you want to proceed (y or n)?\n";
    char answer = 0;
    cin >> answer;

    if (answer == 'y')
        return true;
    return false;
}

// in c++, declarations can appear anywhere
bool accept2()
{
    cout << "Do you want to proceed (y or n)?\n";
    char answer = 0;
    cin >> answer;

    switch (answer) {
        case 'y':
            return true;
        case 'n':
            return false;
        default:
            cout << "I'll take that for a no.\n";
            return false;
    }
}

// we can even introduce a variable and then test it
void do_something(vector <int>& v)
{
    if (auto n = v.size(); n != 0) {
        cout << "Vector is not empty" << n << "\n";
    } else {
        // n is in scope here as well
        cout << "Vector is empty" << n << "\n";
    }

    // the function will test irf not zero by default if you do this
    if (auto n = v.size()) {
        // ...
    }
}


