let lines = readfile(glob('./in.txt'))

fun IsNumber(x)
    return '0' <= a:x && a:x <= '9'
endfunction

" list mapping each cross symbol to its adjacent numbers
let cross_numbers = []

let i = 0
while i < len(lines)
    let j = 0
    let cross_numbers += [[]]
    while j < strlen(lines[i])
        let cross_numbers[-1] += [[]]
        let j += 1
    endwhile
    let i += 1
endwhile

let i = 0
while i < len(lines)
    " loop through characters
    let l = 0
    let r = 0
    let n = strlen(lines[i])

    while l < n
        " Identifying numbers
        while r < n && IsNumber(lines[i][l]) == IsNumber(lines[i][r])
            let r += 1
        endwhile

        " Checking for symbols
        if IsNumber(lines[i][l])
            let value = str2nr(lines[i][l : r-1])
            let symbols = 0

            " Looking for symbols above/below
            let j = max([0, l - 1])
            while j < min([n, r + 1])
                if i - 1 >= 0 && lines[i - 1][j] == '*'
                    let cross_numbers[i - 1][j] += [value]
                endif
                if i + 1 < len(lines) && lines[i + 1][j] == '*'
                    let cross_numbers[i + 1][j] += [value]
                endif
                let j += 1
            endwhile

            " Looking for symbols to the left/right
            if l - 1 >= 0 && lines[i][l - 1] == '*'
                let cross_numbers[i][l - 1] += [value]
            endif
            if r < n && lines[i][r] == '*'
                let cross_numbers[i][r] += [value]
            endif
        endif

        let l = r
    endwhile
    let i += 1
endwhile

let total = 0

let i = 0
while i < len(lines)
    let j = 0
    let cross_numbers += [[]]
    while j < strlen(lines[i])
        if len(cross_numbers[i][j]) == 2
            let total += cross_numbers[i][j][0] * cross_numbers[i][j][1]
        endif
        let j += 1
    endwhile
    let i += 1
endwhile

echo total
