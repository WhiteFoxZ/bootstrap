package com.ems.common.schedule;

import java.sql.Connection;
import java.util.Date;

import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.quartz.JobKey;

import com.ems.common.dbcp.DBCPManager;
import com.ems.common.dbcp.DBManager;
import com.ems.common.dbcp.DataSource;
import com.ems.common.smtp.GMailSender;
import com.ems.common.util.EmsHashtable;
import com.ems.common.util.QueryXMLParser;


public class MailSenderJob implements Job {

	private static Logger log = Logger.getLogger(MailSenderJob.class.getName());

	private DataSource ds=null;
	private DBManager dbm=null;



    /**
     * Quartz requires a public empty constructor so that the
     * scheduler can instantiate the class whenever it needs.
     */
    public MailSenderJob() {

    	DBCPManager dbcp = DBCPManager.getInstance("mysql.db.properties");

    	ds = dbcp.getDatasource();

    	dbm = new DBManager(ds);

    }

    /**
     * <p>
     * Called by the <code>{@link org.quartz.Scheduler}</code> when a
     * <code>{@link org.quartz.Trigger}</code> fires that is associated with
     * the <code>Job</code>.
     * </p>
     *
     * @throws JobExecutionException
     *             if there is an exception while executing the job.
     */
    public void execute(JobExecutionContext context)
        throws JobExecutionException {

    	log.info("**************** execute *****************");

    	EmsHashtable[] admin = dbm.selectMultipleRecord("SELECT USERNAME, TEL1, TEL2, LOGINID, LOGINPW, ACCESSPW, EMAIL  FROM user_info where status='1' "
    			, new String[]{});

    	for (int i = 0; i < admin.length; i++) {

    		sendMail(admin[i].getString("LOGINID"), admin[i].getString("EMAIL"));

//    		log.info(admin[i].getString("LOGINID") + "   "+admin[i].getString("EMAIL"));

		}

        // This job simply prints out its job name and the
        // date and time that it is running
        JobKey jobKey = context.getJobDetail().getKey();
        log.info("MailSendJob says: " + jobKey + " executing at " + new Date());
    }

    private void sendMail(String loginid, String tomail){

    	Connection con =null;

    	try{

    		log.info("5초후 송신");

    		Thread.sleep(1000*3);

    		  String sql = QueryXMLParser.getQuery(this.getClass(), "MailSenderJob.xml", "list_sql");



        	EmsHashtable[] hash = dbm.selectMultipleRecord(sql
        			, new String[]{loginid});

        	if(hash!=null && hash.length>0){
            	StringBuffer sb = new StringBuffer("예약등록후 24 시간 지난 입금하지 않는 고객정보 입니다.<p>\n");


            	GMailSender mail=new GMailSender();

            	sb.append("<table width='500' style='border-style: solid; border-width: 1px; border-collapse: collapse;' \n>");
            	sb.append("<tr >\n");
            	sb.append("<th style='border-style: solid; border-width: 2px; background-color:yellow;'>").append("이름").append("</th>\n");
            	sb.append("<th style='border-style: solid; border-width: 2px; background-color:yellow;'>").append("전화").append("</th>\n");
            	sb.append("<th style='border-style: solid; border-width: 2px; background-color:yellow;'>").append("기간").append("</th>\n");
            	sb.append("<th style='border-style: solid; border-width: 2px; background-color:yellow;'>").append("데크").append("</th>\n");
            	sb.append("</tr>\n");



            	for(int i=0; i<hash.length; i++){

            		sb.append("<tr >\n");
                	sb.append("<td style='border-style: solid; border-width: 1px; border-collapse: collapse; text-align:center; '>").append( hash[i].getString("USER_NAME") ).append("</td>\n");
                	sb.append("<td style='border-style: solid; border-width: 1px; border-collapse: collapse; text-align:center; '>").append( hash[i].getString("USER_TEL1") ).append("</td>\n");
                	sb.append("<td style='border-style: solid; border-width: 1px; border-collapse: collapse; text-align:center; '>").append( hash[i].getString("PROID") ).append("</td>\n");
                	sb.append("<td style='border-style: solid; border-width: 1px; border-collapse: collapse; text-align:center; '>").append( hash[i].getString("DECK") ).append("</td>\n");
                	sb.append("</tr>\n");

            	}


            	sb.append("</tr><table>\n");


    	    	mail.mailSender("이승용","입금하지 않은 고객", tomail, sb.toString());
    	    	log.info(sb.toString());
    	    	sb.setLength(0);



        	}



        	String sq2 = QueryXMLParser.getQuery(this.getClass(), "MailSenderJob.xml", "delete_sql2");
	    	//한달지난 정보 자동 삭제처리
	    	con = dbm.getConnection();

	    	dbm.delete(con, sq2, new String[]{loginid,loginid,loginid});

	    	dbm.commitChange(con);



    	}catch(Exception e){
    		log.info(e.toString());

    		dbm.rollbackChange(con);

    	}finally{

    	}


    }

}
