local snapshots = {}

-- deviation: } instead of }
snapshots['collapses big diffs to patch format 1'] = [[
- Expected
+ Received

@@ -6,9 +6,9 @@
      4,
      5,
      6,
      7,
      8,
-     9,
      10,
+     9,
    },
  }]]

-- deviation: all context number of lines tests use } instead of }
snapshots['context number of lines: -1 (5 default) 1'] = [[
- Expected  - 1
+ Received  + 1

@@ -6,9 +6,9 @@
      4,
      5,
      6,
      7,
      8,
-     9,
      10,
+     9,
    },
  }]]

snapshots['context number of lines: 0  1'] = [[
- Expected  - 1
+ Received  + 1

@@ -11,1 +11,0 @@
-     9,
@@ -13,0 +12,1 @@
+     9,]]

snapshots['context number of lines: 1  1'] = [[
- Expected  - 1
+ Received  + 1

@@ -10,4 +10,4 @@
      8,
-     9,
      10,
+     9,
    },]]

snapshots['context number of lines: 2  1'] = [[
- Expected  - 1
+ Received  + 1

@@ -9,6 +9,6 @@
      7,
      8,
-     9,
      10,
+     9,
    },
  }]]

snapshots['context number of lines: 3.1 (5 default) 1'] = [[
- Expected  - 1
+ Received  + 1

@@ -6,9 +6,9 @@
      4,
      5,
      6,
      7,
      8,
-     9,
      10,
+     9,
    },
  }]]

-- deviation: nil instead of undefined
snapshots['context number of lines: nil (5 default) 1'] = [[
- Expected  - 1
+ Received  + 1

@@ -6,9 +6,9 @@
      4,
      5,
      6,
      7,
      8,
-     9,
      10,
+     9,
    },
  }]]

snapshots['diffStringsUnified edge cases empty both a and b 1'] = [[
- Expected  - 0
+ Received  + 0

]]

snapshots['diffStringsUnified edge cases empty only a 1'] = [[
- Expected  - 0
+ Received  + 1

+ one-line string]]

snapshots['diffStringsUnified edge cases empty only b 1'] = [[
- Expected  - 1
+ Received  + 0

- one-line string]]

snapshots['diffStringsUnified edge cases equal both non-empty 1'] = [[
- Expected  - 0
+ Received  + 0

  one-line string]]

snapshots['diffStringsUnified edge cases multiline has no common after clean up chaff 1'] = [[
- Expected  - 2
+ Received  + 2

- delete
- two
+ insert
+ 2]]

snapshots['diffStringsUnified edge cases one-line has no common after clean up chaff 1'] = [[
- Expected  - 1
+ Received  + 1

- delete
+ insert]]

-- deviation: edited to say 'Table' and 'Function anonymous', ordering changed
snapshots['falls back to not call toJSON if it throws and then objects have differences 1'] = [[
- Expected  - 1
+ Received  + 1

  Table {
-   "line": 1,
+   "line": 2,
    "toJSON": [Function anonymous],
  }]]

-- deviation: edited to say 'Table' and 'Function anonymous', ordering changed, unescaped backticks
snapshots['falls back to not call toJSON if serialization has no differences but then objects have differences 1'] = [[
Compared values serialize to the same structure.
Printing internal object structure without calling `toJSON` instead.

- Expected  - 1
+ Received  + 1

  Table {
-   "line": 1,
+   "line": 2,
    "toJSON": [Function anonymous],
  }]]

snapshots['oneline strings 1'] = [[
- Expected  - 1
+ Received  + 1

- ab
+ aa]]

snapshots['oneline strings 2'] = [[
- Expected  - 1
+ Received  + 1

- 123456789
+ 234567890]]

snapshots['oneline strings 3'] = [[
- Expected  - 1
+ Received  + 2

- oneline
+ multi
+ line]]

snapshots['oneline strings 4'] = [[
- Expected  - 2
+ Received  + 1

- multi
- line
+ oneline]]

-- deviation: unescaped backticks and ${}
snapshots['options 7980 diff 1'] = [[
- Original
+ Modified

- `${Ti.App.name} ${Ti.App.version} ${Ti.Platform.name} ${Ti.Platform.version}`
+ `${Ti.App.getName()} ${Ti.App.getVersion()} ${Ti.Platform.getName()} ${Ti.Platform.getVersion()}`]]

-- deviation: unescaped backticks and ${}
snapshots['options 7980 diffStringsUnified 1'] = [[
- Original
+ Modified

- `${Ti.App.<i>n</i>ame} ${Ti.App.<i>v</i>ersion} ${Ti.Platform.<i>n</i>ame} ${Ti.Platform.<i>v</i>ersion}`
+ `${Ti.App.<i>getN</i>ame<i>()</i>} ${Ti.App.<i>getV</i>ersion<i>()</i>} ${Ti.Platform.<i>getN</i>ame<i>()</i>} ${Ti.Platform.<i>getV</i>ersion<i>()</i>}`]]

snapshots['options change color diffStringsUnified 1'] = [[
- Expected
+ Received

- delete
- changed <b>from
+ changed <b>to
+ insert
<y>  common]]

snapshots['options change color no diff 1'] = [[<y>Compared values have no visual difference.</]]

-- deviation: Table {} instead of Array []
snapshots['options change indicators diff 1'] = [=[
< Expected
> Received

  Table {
<   "delete",
<   "change from",
>   "change to",
>   "insert",
    "common",
  }]=]

-- deviation: Table {} instead of Array []
snapshots['options common diff 1'] = [=[
- Expected
+ Received

= Table {
-   "delete",
-   "change from",
+   "change to",
+   "insert",
=   "common",
= }]=]

-- deviation: Table {} instead of Array []
snapshots['options includeChangeCounts false diffLinesUnified 1'] = [=[
- Expected
+ Received

  Table {
-   "delete",
-   "change from",
+   "change to",
+   "insert",
    "common",
  }]=]

snapshots['options includeChangeCounts false diffStringsUnified 1'] = [[
- Expected
+ Received

- change <i>from</i>
+ change <i>to</i>
  common]]

snapshots['options includeChangeCounts true padding diffLinesUnified a has 2 digits 1'] = [[
- Before  - 10
+ After   +  1

  common
- a
- a
- a
- a
- a
- a
- a
- a
- a
- a
+ b]]

snapshots['options includeChangeCounts true padding diffLinesUnified b has 2 digits 1'] = [[
- Before  -  1
+ After   + 10

  common
- a
+ b
+ b
+ b
+ b
+ b
+ b
+ b
+ b
+ b
+ b]]

snapshots['options includeChangeCounts true padding diffStringsUnified 1'] = [[
- Before  - 1
+ After   + 1

- change <i>from</i>
+ change <i>to</i>
  common]]

-- deviation: Table {} instead of Array []
snapshots['options omitAnnotationLines true diff 1'] = [=[
  Table {
-   "delete",
-   "change from",
+   "change to",
+   "insert",
    "common",
  }]=]

snapshots['options omitAnnotationLines true diffStringsUnified and includeChangeCounts true 1'] = [[
- change <i>from</i>
+ change <i>to</i>
  common]]

snapshots['options omitAnnotationLines true diffStringsUnified empty strings 1'] = ''

snapshots['options trailingSpaceFormatter diffDefault default no color 1'] = [[
- Expected
+ Received

- delete 1 trailing space: 
+ delete 1 trailing space:
  common 2 trailing spaces:  
- insert 1 trailing space:
+ insert 1 trailing space: ]]

snapshots['options trailingSpaceFormatter diffDefault middle dot 1'] = [[
- Expected
+ Received

- delete 1 trailing space:·
+ delete 1 trailing space:
  common 2 trailing spaces:··
- insert 1 trailing space:
+ insert 1 trailing space:·]]

snapshots['options trailingSpaceFormatter diffDefault yellowish common 1'] = [[
- Expected
+ Received

- delete 1 trailing space: 
+ delete 1 trailing space:
  common 2 trailing spaces:<Y>  </>
- insert 1 trailing space:
+ insert 1 trailing space: ]]

return snapshots