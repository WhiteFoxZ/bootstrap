package com.ems.common.listener;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.Logger;

import com.ems.common.dbcp.DBCPManager;
import com.ems.common.dbcp.DataSource;

public class DBCPListener implements ServletContextListener {
    private ServletContext context = null;
    private static Logger log = Logger.getLogger(DBCPListener.class.getName());

    DBCPManager dbcp=null;


    public void contextInitialized(ServletContextEvent event) {
        context = event.getServletContext();

        dbcp = DBCPManager.getInstance("mysql.db.properties");

        com.ems.common.dbcp.DataSource ds = dbcp.getDatasource();

        log.info("최초생성 "+ds.toString());

        context.setAttribute(dbcp.getDataSourceName(),dbcp.getDatasource());

    }

    public void contextDestroyed(ServletContextEvent event) {
        context = event.getServletContext();

        try {

        	DataSource ds = (DataSource)context.getAttribute(dbcp.getDataSourceName());

        	if(ds!=null){


        	log.info("종료전 "+ds.toString());

        	ds.close();

        	log.info("종료후 "+ds.toString());
        	}


        } catch (Exception e) {
            e.printStackTrace();
        }finally{

        }
    }


}
