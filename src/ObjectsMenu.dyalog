:Namespace ObjectsMenu
    ⎕IO←1
    ⎕ML←1

    dis←{⊃⍣(2=≡⍵)⊢⍵}

    ∇ Install;owx
      ⎕SE.⎕WX←3⊣owx←⎕SE.⎕WX
      ∆OnWorkspaceLoaded←dis ⎕SE.onWorkspaceLoaded
      ⎕SE.onWorkspaceLoaded←'Init'
      ⎕SE.⎕WX←owx
	  ⎕←''
	  ⎕←'***Objects Menu installed.***'
      ⎕←'***Please save your session and restart Dyalog.***' 
    ∇

    ∇ Init msg;qed;old;cb
      :If 0≢⊃∆OnWorkspaceLoaded
          ⍎'⎕SE.',∆OnWorkspaceLoaded,' msg'
      :EndIf
      CreateMenu
      qed←⎕SE.⎕WG'Editor'
      old←dis qed.onAfterFix
      cb←'OM_OnAfterFix'
      :If cb≢(-≢cb)↑old
          ∆OnAfterFix←old
          qed.onAfterFix←cb
      :EndIf
    ∇

    ∇ OM_OnAfterFix msg;space;name;new
      space name new←¯3↑msg
      Add(⍕space),'.',name{~0∊⍴⍵:⍵ ⋄ ⍺}new
      :If 0≢⊃∆OnAfterFix
          ⍎'⎕SE.',∆OnAfterFix,' msg'
      :EndIf
    ∇

    ∇ Add item;m
      m←⎕SE.mb.Objects
      m.RecentObjects←{(9⌊≢⍵)↑⍵}(⊂item)∪m.RecentObjects
      m.(mis↑⍨←≢RecentObjects)
      m.(mis.Caption←(⍳≢RecentObjects){'&',(⍕⍺),' ',⍵}¨RecentObjects)
      m.mis.(onSelect←'⍎⎕ED ''',3↓Caption,'''')
    ∇

    ∇ {m}←CreateMenu;i;caption;name;∆
      m←⎕SE.mb.(Objects←⎕NEW'Menu'(⊂'Caption' 'O&bjects'))
      ∆←''
      ∆,←⊂'∇' '&Function/Operator'
      ∆,←⊂'→' '&Simple Character Vector'
      ∆,←⊂'∊' '&Vector of Character Vectors'
      ∆,←⊂'-' 'Character &Matrix'
      ∆,←⊂'⍟' '&Namespace Script'
      ∆,←⊂'○' '&Class Script'
      ∆,←⊂'∘' '&Interface'
      m.new←m.⎕NEW'Menu'(⊂'Caption' '&New')
      m.newTypes←m.new.⎕NEW∘⊂¨(≢∆)/⊂'MenuItem'
      m.newTypes.(symbol Caption)←∆
      m.newTypes.onSelect←⊂'New'
      m.sep←m.⎕NEW'Separator'⍬
      m.(mis←0/⎕NEW⊂'MenuItem')
      m.RecentObjects←''
    ∇

    ∇ New msg;item;symbols;name;type;caller
      item←1⊃msg
      'What would you like to call your new object?'
      name←⍞~' '
      caller←⊃⎕NSI
      name←caller,'.',name
      item.symbol ⎕ED name
    ∇

:EndNamespace