function tab(caller) {
    var tabholder = document.getElementById("sub-header");
    var tabs = tabholder.childNodes;
    for (var i = 0; i < tabs.length; i++) {
        if (tabs[i].nodeName == "SPAN")  
        tabs[i].setAttribute("class","sub-header");
    }
    caller.setAttribute("class", "sub-header-selected");
    return;
}