let lines = readfile(glob('./in.txt'))

fun IsNumber(x)
    return '0' <= a:x && a:x <= '9'
endfunction

let total = 0

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
                if i - 1 >= 0 && lines[i - 1][j] != '.'
                    let symbols += 1
                endif
                if i + 1 < len(lines) && lines[i + 1][j] != '.'
                    let symbols += 1
                endif
                let j += 1
            endwhile

            " Looking for symbols to the left/right
            if l - 1 >= 0 && lines[i][l - 1] != '.'
                let symbols += 1
            endif
            if r < n && lines[i][r] != '.'
                let symbols += 1
            endif

            if symbols > 0
                let total += value
            endif
        endif

        let l = r
    endwhile
    let i += 1
endwhile

echo total
