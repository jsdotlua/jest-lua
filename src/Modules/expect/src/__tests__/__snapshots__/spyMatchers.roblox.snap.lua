local snapshots = {}

snapshots['Lua tests nil argument calls lastCalledWith works with trailing nil argument 1'] = [=[
[2mexpect([22m[31mjest:fn()[39m[2m).[22mlastCalledWith[2m([22m[32m...expected[39m[2m)[22m

Expected: [32m"a"[39m, [32m"b"[39m
Received: [2m"a"[22m, [2m"b"[22m, [31mnil[39m

Number of calls: [31m1[39m]=]

snapshots['Lua tests nil argument calls lastCalledWith works with inner nil argument 1'] = [=[
[2mexpect([22m[31mjest:fn()[39m[2m).[22mlastCalledWith[2m([22m[32m...expected[39m[2m)[22m

Expected: [32m"a"[39m, [32mnil[39m
Received: [2m"a"[22m, [2mnil[22m, [31m"b"[39m

Number of calls: [31m1[39m]=]

snapshots['Lua tests nil argument calls lastCalledWith works with inner nil argument 2'] = [=[
[2mexpect([22m[31mjest:fn()[39m[2m).[22mnever[2m.[22mlastCalledWith[2m([22m[32m...expected[39m[2m)[22m

Expected: never [32m"a"[39m, [32mnil[39m, [32m"b"[39m

Number of calls: [31m1[39m]=]

snapshots['Lua tests nil argument calls lastCalledWith complex call with nil 1'] = [=[
[2mexpect([22m[31mjest:fn()[39m[2m).[22mlastCalledWith[2m([22m[32m...expected[39m[2m)[22m

[32m- Expected[39m
[31m+ Received[39m

  [2m"a"[22m,
[2m  Table {[22m
[2m    1,[22m
[32m-   3,[39m
[31m+   2,[39m
[2m  }[22m,
  [2mnil[22m,
[32m- "b"[39m,
[31m+ nil[39m,

Number of calls: [31m1[39m]=]

snapshots['Lua tests nil argument calls lastCalledWith complex call with nil 2'] = [=[
[2mexpect([22m[31mjest:fn()[39m[2m).[22mlastCalledWith[2m([22m[32m...expected[39m[2m)[22m

[32m- Expected[39m
[31m+ Received[39m

  [2m"a"[22m,
  [2m{1, 2}[22m,
  [2mnil[22m,
[31m+ nil[39m,]=]

snapshots['Lua tests nil argument calls lastCalledWith complex multi-call with nil 1'] = [=[
[2mexpect([22m[31mjest:fn()[39m[2m).[22mlastCalledWith[2m([22m[32m...expected[39m[2m)[22m

Expected: [32m"a"[39m, [32m{1, 2}[39m, [32mnil[39m
Received
       1: [2m"a"[22m, [2m{1, 2}[22m
->     2
           [2m"a"[22m,
          [2m{1, 2}[22m,
          [2mnil[22m,
        [31m+ nil[39m,

Number of calls: [31m2[39m]=]

snapshots['Lua tests nil argument calls toBeCalledWith multi-call 1'] = [=[
[2mexpect([22m[31mjest:fn()[39m[2m).[22mtoBeCalledWith[2m([22m[32m...expected[39m[2m)[22m

Expected: [32m"a"[39m, [32m"b"[39m
Received
       1: [2m"a"[22m, [2m"b"[22m, [31mnil[39m
       2: [2m"a"[22m, [2m"b"[22m, [31mnil[39m, [31mnil[39m, [31m4[39m

Number of calls: [31m2[39m]=]

snapshots['Lua tests nil argument calls toBeCalledWith multi-call 2'] = [=[
[2mexpect([22m[31mjest:fn()[39m[2m).[22mtoBeCalledWith[2m([22m[32m...expected[39m[2m)[22m

Expected: [32m"a"[39m, [32m"b"[39m, [32mnil[39m, [32mnil[39m, [32m4[39m, [32mnil[39m
Received
       1: [2m"a"[22m, [2m"b"[22m, [2mnil[22m
       2: [2m"a"[22m, [2m"b"[22m, [2mnil[22m, [2mnil[22m, [2m4[22m

Number of calls: [31m2[39m]=]

return snapshots