<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE helpset
  PUBLIC "-//Sun Microsystems Inc.//DTD JavaHelp HelpSet Version 1.0//EN" "http://java.sun.com/products/javahelp/helpset_1_0.dtd">
<helpset version="1.0">
   <title>Documentation de création de Doc avec Dita</title>
   <maps>
      <homeID>Topic_Documentation</homeID>
      <mapref location="hierarchy.jhm"/>
   </maps>
   <view>
      <name>TOC</name>
      <label>TOC</label>
      <type>javax.help.TOCView</type>
      <data>hierarchy.xml</data>
   </view>
   <view mergetype="javax.help.AppendMerge">
      <name>index</name>
      <label>Index</label>
      <type>javax.help.IndexView</type>
      <data>hierarchy_index.xml</data>
   </view>
   <view>
      <name>Search</name>
      <label>Search</label>
      <type>javax.help.SearchView</type>
      <data engine="com.sun.java.help.search.DefaultSearchEngine"> 
          JavaHelpSearch </data>
   </view>
</helpset>