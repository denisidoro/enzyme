WriteBMP(file,colors,width=16,height=16,padded=0)
{
  ;first check if we have the right number of pixels
   if padded = 0
      if strlen(colors)/6 <> height*width
         msgbox,% "Pixel Mismatch detected!`n(The Height*Width you specified does not match the number of pixels you provided, or the padding is incorrect) The BMP will be corrupted.`nWidth:" width " Height:" Height "`nPixels provided:" strlen(colors)/6 " Pixels needed: " width*height
   if padded
      if (strlen(colors)/6 - mod(width,4)*height)<> height*width
         msgbox,% "Pixel Mismatch detected!`n(The Height*Width you specified does not match the number of pixels you provided, or the padding is incorrect) The BMP will be corrupted.`nWidth:" width " Height:" Height "`nPixels provided:" strlen(colors)/6 " Pixels needed: " width*height
  ;if the bitmap is not padded we need to pad it
   if (padded = 0) and (mod(width,4) <> 0) ;our bitmap was not provided with padding and it needs it
   {
      loop, %height%
      {
         stringmid,row,colors,% width * 6 * (A_index-1) + 1,% width*6
         colorspadded := colorspadded row removehex(padhex(0,mod(width,4)))  ;add the needed number of 00 bytes
      }
      colors := colorspadded
   }
  ;now we need to create the actual bitmap, starting with the header
   setformat,integer,H
   width := removehex(padhex(width+0,4))      ;this makes the width and height into "words" or 4 bytes long
   height := removehex(padhex(height+0,4))
   ;          B M size    reserved     offbits bitsize                    planes  bitcount (24 bit), and the rest is color table (0s)
   BMPHex := "424d0000000000000000" . "3600000028000000" . width . height "0100" . "1800" . "000000000000000000000000000000000000000000000000" . colors

  ;Create the file
   Handle :=  DllCall("CreateFile","str",file,"Uint",0x40000000
                  ,"Uint",0,"UInt",0,"UInt",4,"Uint",0,"UInt",0)
   Loop
   {
     if strlen(BMPHex) = 0
        break
     StringLeft, Hex, BMPHex, 2         
     StringTrimLeft, BMPHex, BMPHex, 2 
     Hex = 0x%Hex%
     DllCall("WriteFile","UInt", Handle,"UChar *", Hex
     ,"UInt",1,"UInt *",UnusedVariable,"UInt",0)
    }
  ;close the file
   DllCall("CloseHandle", "Uint", Handle)
   return 0
}

padhex(hexin,bytes)                                ;pads a hex number to the specified byte length
{
   if Mod(strlen(hexin),2)                         ;the string is an odd number of digits long
   {
      hexin := removehex(hexin)                    ; remove the "0x" temporarily
      hexin := "0x0" hexin   ;for ex: A into 0x0A  ; now add "0x0"
   }
   loop, % bytes - strlen(hexin)/2 + 1             ;add zeros to the end till we get the desired byte length
      hexin := hexin "00"
   return hexin
}

removehex(hexin)                                   ;removes the 0x from hex
{
   stringleft,beg,hexin,2
   if beg = 0x
      stringtrimleft,hexin,hexin,2
   return hexin
}