local snapshots = {}

snapshots['Lua tests nil argument calls lastCalledWith works with trailing nil argument 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"a"</>, <g>"b"</>
Received: <d>"a"</>, <d>"b"</>, <r>nil</>

Number of calls: <r>1</>
]=]

snapshots['Lua tests nil argument calls lastCalledWith works with inner nil argument 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"a"</>, <g>nil</>
Received: <d>"a"</>, <d>nil</>, <r>"b"</>

Number of calls: <r>1</>
]=]

snapshots['Lua tests nil argument calls lastCalledWith works with inner nil argument 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"a"</>, <g>nil</>, <g>"b"</>

Number of calls: <r>1</>
]=]

snapshots['Lua tests nil argument calls lastCalledWith complex call with nil 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastCalledWith<d>(</><g>...expected</><d>)</>

<g>- Expected</>
<r>+ Received</>

  <d>"a"</>,
<d>  Table {</>
<d>    1,</>
<g>-   3,</>
<r>+   2,</>
<d>  }</>,
  <d>nil</>,
<g>- "b"</>,
<r>+ nil</>,

Number of calls: <r>1</>
]=]

snapshots['Lua tests nil argument calls lastCalledWith complex call with nil 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastCalledWith<d>(</><g>...expected</><d>)</>

<g>- Expected</>
<r>+ Received</>

  <d>"a"</>,
  <d>{1, 2}</>,
  <d>nil</>,
<r>+ nil</>,

Number of calls: <r>1</>
]=]

snapshots['Lua tests nil argument calls lastCalledWith complex multi-call with nil 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"a"</>, <g>{1, 2}</>, <g>nil</>
Received
       1: <d>"a"</>, <d>{1, 2}</>
->     2
           <d>"a"</>,
          <d>{1, 2}</>,
          <d>nil</>,
        <r>+ nil</>,

Number of calls: <r>2</>
]=]

snapshots['Lua tests nil argument calls toBeCalledWith multi-call 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"a"</>, <g>"b"</>
Received
       1: <d>"a"</>, <d>"b"</>, <r>nil</>
       2: <d>"a"</>, <d>"b"</>, <r>nil</>, <r>nil</>, <r>4</>

Number of calls: <r>2</>
]=]

snapshots['Lua tests nil argument calls toBeCalledWith multi-call 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"a"</>, <g>"b"</>, <g>nil</>, <g>nil</>, <g>4</>, <g>nil</>
Received
       1: <d>"a"</>, <d>"b"</>, <d>nil</>
       2: <d>"a"</>, <d>"b"</>, <d>nil</>, <d>nil</>, <d>4</>

Number of calls: <r>2</>
]=]

return snapshots