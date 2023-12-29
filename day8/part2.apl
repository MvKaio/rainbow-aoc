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
    cur ⊢← {⍵{⍵⊃1⊃table⊃⍨(↑table)[;0]⍳↓⍺}dir⌷⍨n|cnt}¨cur
    cnt +← 1
    cur
}

get_len ← {
    cnt ⊢← 0
    cur ⊢← ↓⍵
    _←get_next⍣{(≢cur)=+/{'Z'=2⌷⍵}¨⍺} 0
    cnt
}

⊢cur ← names/⍨{'A'=2⌷⍵}¨names
⊢cycles←get_len¨cur
⎕←13 0⍕^/cycles
