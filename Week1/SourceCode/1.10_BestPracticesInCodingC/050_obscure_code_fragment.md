f = open(fn, 'r')
for i in f:
    x = get(i)
    if condition(x):
        a = compute(x)
        if a < 3.14:
            do_something(a)
f.close()

