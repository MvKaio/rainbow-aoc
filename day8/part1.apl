gen ← {
    cmd←'='(≠⊆⊢)⍵
    (1⊃cmd)←','(≠⊆⊢)1⊃cmd
    cmd
}

lines←~∘' ()'¨(⊃∘⎕NGET 1,⍨⊂)'in.txt'
table←gen¨(1<⍳≢lines)/lines
dir←'LR'⍳0⊃lines
n←≢dir

get_next ← {
    cur ⊢← cur{⍵⊃1⊃table⊃⍨(↑table)[;0]⍳↓⍺}dir⌷⍨n|cnt
    cnt +← 1
    cur
}

cnt ← 0
cur ← 'AAA'
get_next⍣{(≢⍺)=+/'ZZZ'=⍺} 0
⎕←cnt
