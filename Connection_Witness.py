def check_poss(i_,j_, n):
    if i_ == 0 or j_ == 0 or i_ == n+1 or j_ == n+1:
        return False
    return True

n = int(input())
ex=int(input())
print("<{}, {}, {}, {}>".format(1,ex,0,0))
print("<{}, {}, {}, {}>".format(n+1,n,n,n))
for i in range(1,n+1):
    for j in range(1,n+1):
        if check_poss(i+1,j, n):
            print("<{}, {}, {}, {}>".format(i,j,i+1,j))
        if check_poss(i-1,j, n):
            print("<{}, {}, {}, {}>".format(i,j,i-1,j))
        if check_poss(i,j+1, n):
            print("<{}, {}, {}, {}>".format(i,j,i,j+1))
        if check_poss(i,j-1, n):
            print("<{}, {}, {}, {}>".format(i,j,i,j-1))
        
