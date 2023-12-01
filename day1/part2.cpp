#include <bits/stdc++.h>
using namespace std;

int main() {
    string s;
    int sum = 0;

    vector<string> digits = {
        "zero",
        "one",
        "two",
        "three",
        "four",
        "five",
        "six",
        "seven",
        "eight",
        "nine",
    };

    while (cin >> s) {
        vector<int> v;
        for (int i = 0; i < s.size(); i++) {
            if ('0' <= s[i] && s[i] <= '9')
                v.push_back(s[i] - '0');
            else {
                int d = 0;
                for (string digit : digits) {
                    if (i + digit.size() <= s.size() && s.substr(i, digit.size()) == digit) {
                        v.push_back(d);
                    }
                    d += 1;
                }
            }
        }
        sum += v.front() * 10 + v.back();
    }
    cout << sum << endl;
}
