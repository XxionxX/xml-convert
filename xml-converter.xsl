<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:key name="customerPO" match="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic" use="@name"/>

<xsl:template match="/">
  <order>
    <sourceOrderID><xsl:value-of select="*/*/*/OrderRequestHeader/@orderID"/></sourceOrderID>
    <stCountry><xsl:value-of select="*/*/*/*/*/*/PostalAddress/Country/@isoCountryCode"/></stCountry>
    <stZip><xsl:value-of select="*/*/*/*/*/*/PostalAddress/Street"/></stZip>
    <stState><xsl:value-of select="*/*/*/*/*/*/PostalAddress/State"/></stState>
    <stCity><xsl:value-of select="*/*/*/*/*/*/PostalAddress/City"/></stCity>
    <stAttention><xsl:value-of select="*/*/*/*/*/*/PostalAddress/DeliverTo"/></stAttention>
    <stNameCompany><xsl:value-of select="*/*/*/*/ShipTo/Address/Name"/></stNameCompany>
    <shipMethod><xsl:value-of select="*/*/*/*/Shipping/Description"/></shipMethod>
    <stStreet><xsl:value-of select="*/*/*/*/*/*/PostalAddress/Street"/></stStreet>
    <createDate><xsl:value-of select="*/*/*/OrderRequestHeader/@orderDate"/></createDate>
  
    <xsl:for-each select="key('customerPO','bill_code2')">
      <customerPO><xsl:value-of select="."/></customerPO> <!-- The '.' is the current value-->
    </xsl:for-each>

    <btEmail><xsl:value-of select="*/*/*/OrderRequestHeader/Contact/Email"/></btEmail>
    <btNameCompany><xsl:value-of select="*/*/*/OrderRequestHeader/Contact/Name"/></btNameCompany>

    <xsl:for-each select="*/*/OrderRequest/ItemOut">
      <item>
        <memo><xsl:value-of select="ItemDetail/Extrinsic[@name='tag']" /></memo>
        <note><xsl:value-of select="Comments"/></note>
        <!--This selects a node via the attribute: node/nodes[@attribute='value/string']-->
        <fileF><xsl:value-of select="ItemDetail/Extrinsic[@name='artwork']" /></fileF>
        <productDesc><xsl:value-of select="ItemDetail/Description"/></productDesc>
        <quantity><xsl:value-of select="./@quantity"/></quantity>
        <productID><xsl:value-of select="ItemID/SupplierPartID"/></productID>
        <customerApproval><xsl:value-of select="/*/*/*/OrderRequestHeader/Extrinsic[@name='customerApproval']"/></customerApproval>
      </item>
    </xsl:for-each>
  </order>
</xsl:template>
</xsl:stylesheet> 
</xsl:stylesheet> 
