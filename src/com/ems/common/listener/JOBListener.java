package com.ems.common.listener;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.Logger;

import com.ems.common.schedule.MailSenderJobCronTrigger;

public class JOBListener implements ServletContextListener {
    private ServletContext context = null;
    private static Logger log = Logger.getLogger(JOBListener.class.getName());

    MailSenderJobCronTrigger trigger=null;


    public void contextInitialized(ServletContextEvent event) {
        context = event.getServletContext();




        try{
        	log.info("JOBListener start 2초후 ");

        	log.info(context.getContextPath().replaceAll("/", ""));

        	Thread.sleep(1000*2);
        	trigger = new MailSenderJobCronTrigger(context.getContextPath().replaceAll("/", ""));
        	trigger.run();
        }catch(Exception e){
        	e.printStackTrace();
        }


    }

    public void contextDestroyed(ServletContextEvent event) {
        context = event.getServletContext();

        try {
        	log.info("JOBListener 종료  ");
        	if(trigger!=null)
        	trigger.stop();

        } catch (Exception e) {
            e.printStackTrace();
        }finally{

        }
    }


}
