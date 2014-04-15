# chunking an array for Angular client side

items = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'j']
rows = [0]
rowItems = []
rowItems[0] = []
r = 0
c = 0

for item in items
    rowItems[r][c] = item
    if (c >= 3) 
        r++
        rowItems[r] = []
        rows[r] = r
        c = 0
    else
        c++
    console.log(r + ' ' + c)

for r in rows
    for item, i in rowItems[r]
        console.log(r + ' ' + i + ' ' + item)
    
