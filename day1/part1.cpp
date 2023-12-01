#include <bits/stdc++.h>
using namespace std;

int main() {
    string s;
    int sum = 0;
    while (cin >> s) {
        vector<int> v;
        for (int i = 0; i < s.size(); i++) if ('0' <= s[i] && s[i] <= '9')
            v.push_back(s[i] - '0');
        sum += v.front() * 10 + v.back();
    }
    cout << sum << endl;
}
