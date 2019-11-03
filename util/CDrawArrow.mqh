//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.yjx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"

class CDrawArrow
{  

   private:
      static int s_index;
   
   public:
   
      static bool ArrowUp(datetime time, double price);
      static bool ArrowDown(datetime time, double price);
};

int CDrawArrow::s_index = 0;

static bool CDrawArrow::ArrowUp(datetime time, double price)
{
   s_index += 1;
   int chart_ID = 0;
   string name = "ArrowUp_"+s_index;
   int width = 3;
   
   if(!ObjectCreate(chart_ID,name,OBJ_ARROW_UP,0,time,price))
   {
     Print(__FUNCTION__,
         ": failed to create a ArrowUp! Error code = ",GetLastError());
     return(false);
   }
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,ANCHOR_BOTTOM);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clrRed);
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
   return true;
}

static bool CDrawArrow::ArrowDown(datetime time, double price)
{
   s_index += 1;
   int chart_ID = 0;
   string name = "ArrowDown_"+s_index;
   int width = 3;
   
   if(!ObjectCreate(chart_ID,name,OBJ_ARROW_DOWN,0,time,price))
   {
     Print(__FUNCTION__,
         ": failed to create a ArrowDown! Error code = ",GetLastError());
     return(false);
   }
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,ANCHOR_UPPER);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clrRed);
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
   return true;
}