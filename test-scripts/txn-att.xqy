define variable $doc-stat as xs:string external

xdmp:node-replace(fn:doc("/status-test")/status-test/@status-att, attribute status-att {$doc-stat})
