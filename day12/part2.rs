use std::iter;
use std::fs;

fn solve(springs: &str, parts: Vec<&usize>) -> u64 {
    let n = springs.len();
    let m = parts.len();

    let mut dp: Vec<Vec<u64>> = 
        iter::repeat(
            iter::repeat(0).take(m + 1).collect()
        ).take(n + 1).collect();

    let bytes: Vec<_> = springs.bytes().collect();

    dp[n][m] = 1;
    for i in (0..n).rev() {
        for j in 0..=m {
            if bytes[i] != b'#' {
                dp[i][j] += dp[i + 1][j];
            }
            if j + 1 <= m && i + parts[j] <= n {
               if springs[i..i+parts[j]]
                   .chars()
                   .into_iter()
                   .filter(|&c| { c == '.' })
                   .collect::<Vec<_>>()
                   .len() == 0 {
                    if i + parts[j] == n {
                        dp[i][j] += dp[i + parts[j]][j + 1];
                    } else if bytes[i + parts[j]] != b'#' {
                        dp[i][j] += dp[i + parts[j] + 1][j + 1];
                    }
               }
            }
        }
    }

    dp[0][0]
}

fn main() {
    let file = fs::read_to_string("in.txt")
                .unwrap();
    let lines: Vec<_> = file
                .split('\n')
                .map(|s| {
                    s.split(' ').collect::<Vec<_>>()
                })
                .collect();

    let mut answer: u64 = 0;
    for s in lines {
        if s.len() < 2 {
            continue;
        }
        let parts = s[1]
            .split(',')
            .map(|c| c.parse::<usize>().unwrap())
            .collect::<Vec<_>>();
        answer += solve(
            &format!("{a}?{a}?{a}?{a}?{a}", a=s[0]),
            parts.iter().cycle().take(5 * parts.len()).collect(),
        );
    };

    println!("{}", answer);
}
