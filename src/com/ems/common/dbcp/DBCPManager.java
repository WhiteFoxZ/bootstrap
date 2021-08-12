package com.ems.common.dbcp;

import java.net.URL;
import java.util.Properties;

import org.apache.log4j.Logger;

/**
 * Properties file 정보를 읽어서 DataSource 를 생성해주는 메니저
 * @author LEESR
 *
 */
public class DBCPManager {

	private static Logger log = Logger.getLogger(DBCPManager.class.getName());

    private DataSource ds=null;

    private Properties pro=null;

    private static DBCPManager dm=null;

    public static DBCPManager getInstance(String fileName){

    	if(dm==null){

    		System.out.println("------------------------------>"+fileName);
    		dm = new DBCPManager(fileName);
    	}
    	return dm;

    }

    public DBCPManager(String fileName) {

    	ds = new DataSource();

        pro = new Properties();

        log.debug(fileName + " init ");

        URL url = null;


        try {



            pro.load(DBCPManager.class.getResourceAsStream("mysql.db.properties"));

//        	url = Loader.getResource("mysql.db.properties");

//        	System.out.println("url ===== "+url);

//            pro.load(url.openStream());


            ds.setDefaultAutoCommit(false);
            ds.setDefaultReadOnly(false);

            ds.setDriverClassName(pro.getProperty("driverClassName"));
            ds.setMaxActive(Integer.parseInt(pro.getProperty("maxActive")));
            ds.setMaxIdle(Integer.parseInt(pro.getProperty("maxIdle")));
            ds.setMaxWait(Integer.parseInt(pro.getProperty("maxWait")));

            ds.setUrl(pro.getProperty("url"));
            ds.setUsername(pro.getProperty("username"));
            ds.setPassword(pro.getProperty("password"));

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            System.out.println("getNumActive " + ds.getNumActive() +
                               " getNumIdle " + ds.getNumIdle());
        }
    }

    public String getDataSourceName(){
    	return pro.getProperty("sourceName");

    }

	public com.ems.common.dbcp.DataSource getDatasource() {
		// TODO Auto-generated method stub

		log.debug(ds);

		return (com.ems.common.dbcp.DataSource) ds;
	}


    public static void main(String[] args) {


    }

}


