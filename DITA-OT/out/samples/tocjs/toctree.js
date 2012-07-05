
      var tree;
      
      function treeInit() {
      tree = new YAHOO.widget.TreeView("treeDiv1");
      var root = tree.getRoot();
    

var objd4e5 = { label: "Documentation", href:"Topic/Documentation.html", target:"contentwin" };
    var d4e5 = new YAHOO.widget.TextNode(objd4e5, root, false);var objd4e12 = { label: "Installation d'Eclipse", href:"Topic/Task/Installation.html", target:"contentwin" };
    var d4e12 = new YAHOO.widget.TextNode(objd4e12, d4e5, false);var objd4e19 = { label: "Lancer Eclipse", href:"Topic/Task/Lancer.html", target:"contentwin" };
    var d4e19 = new YAHOO.widget.TextNode(objd4e19, d4e5, false);

var objd4e27 = { label: "Publication", href:"Topic/Publication.html", target:"contentwin" };
    var d4e27 = new YAHOO.widget.TextNode(objd4e27, root, false);var objd4e37 = { label: "PDF", href:"Topic/Task/PDF.html", target:"contentwin" };
    var d4e37 = new YAHOO.widget.TextNode(objd4e37, d4e27, false);


      tree.draw(); 
      } 
      
      YAHOO.util.Event.addListener(window, "load", treeInit); 
    