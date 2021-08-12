package com.ems.action.util;


public class LoggerTest {
 
 private org.apache.log4j.Logger log = org.apache.log4j.Logger.getLogger( this.getClass() );
 

 public void getStr() {
  
  log.debug("TERAN getStr() 시작 \n\n");
  
  

  
 }
 
 public static void main(String s[])
 {
 
	 LoggerTest t = new LoggerTest();
	 
	 t.getStr();
	 
 }
 
}

