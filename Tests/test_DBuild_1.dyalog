﻿ r←test_DBuild_1 dummy;pwd;cmd;args
 r←''
 ⍝ put a few things into # to be sure that "-c" clear them!
 #.⎕CY'dfns'
 #.⎕EX'foo' ⋄ #.foo←'goo'

⍝ run build-script (non-prod mode)
 res←##.Build args←##.TESTSOURCE,'DBuild_1.dyalogbuild -c -q=2 -s=0'

 :If 0 Check∨/' errors encountered.'⍷∊res
     →0 Because('DBuild did not succeed but reported: ',res),(⎕UCS 13),']DBuild ',args,' ⍝ to execute it...' ⋄ :EndIf

 :If 'MyNS0' 'MyNS1'Check #.⎕NL ¯9
     →0 Because'Did not find exactly two namespaces in # but instead got: ',⍕#.⎕NL ¯9 ⋄ :EndIf

 :If 0 0 Check #.MyNS0.(⎕IO ⎕ML)
     →0 Because'New namespace MyNS0 did not have expected ⎕IO/⎕ML (according to defaults) set in script' ⋄ :EndIf
 :If 1 1 Check #.MyNS1.(⎕IO ⎕ML)
     →0 Because'New namespace MyNS1 did not have expected ⎕IO/⎕ML (according to defaults) set in script' ⋄ :EndIf

 :If 'Dollar' 'MyEnvVar' 'ProdFlag'Check #.⎕NL-2.1
     →0 Because'Did not find exactly 3 variables in #' ⋄ :EndIf

 :If (0/⊂'')Check #.⎕NL-3.1
     →0 Because'List of functions in # not empty as expected!' ⋄ :EndIf

 :If 'Test'Check #.ProdFlag
     →0 Because'ProdFlag did not have expected value "Test", but rather "',#.ProdFlag,'"' ⋄ :EndIf

 :If 2=⎕NC'dbval'
     :If 0×dbval Check #.MyEnvVar
         →0 Because'EnvironmentVariable was not retrieved with correct value' ⋄ :EndIf
 :EndIf

 :If 2 Check #.⎕ML
     →0 Because'DEFAULTS did not correctly process ⎕ML' ⋄ :EndIf
 :If 0 Check #.⎕IO
     →0 Because'DEFAULTS did not correctly process ⎕IO' ⋄ :EndIf
 :If 1E¯11 Check #.⎕CT
     →0 Because'DEFAULTS did not correctly process ⎕CT' ⋄ :EndIf
 :If 11 Check #.⎕PP
     →0 Because'DEFAULTS did not correctly process ⎕PP' ⋄ :EndIf

⍝ re-run build-script (this time in production mode)
 {}##.Build,##.TESTSOURCE,'DBuild_1.dyalogbuild -c -p -q=2'

 :If 'Production'Check #.ProdFlag
     →0 Because'ProdFlag did not have expected value "Production", but rather "',#.ProdFlag,'"' ⋄ :EndIf

 res←##.Build args←##.TESTSOURCE,'DBuild_nameclash.dyalogbuild -c -q=2 -s=0'
 :If 1 Check∨/'4 errors encountered.'⍷∊res
     →0 Because'DBuild did not fail with 4 errors (3 nameclashes + final msg) while executing...',(⎕UCS 13),']DBuild ',args ⋄ :EndIf
