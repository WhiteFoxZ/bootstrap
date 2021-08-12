package com.ems.common.schedule;

import static org.quartz.CronScheduleBuilder.cronSchedule;
import static org.quartz.JobBuilder.newJob;
import static org.quartz.TriggerBuilder.newTrigger;

import java.util.Date;

import org.apache.log4j.Logger;
import org.quartz.CronTrigger;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerFactory;
import org.quartz.SchedulerMetaData;
import org.quartz.impl.StdSchedulerFactory;


public class MailSenderJobCronTrigger {

	Scheduler sched =null;
	String name;
	String group;

	private static Logger log = Logger.getLogger(MailSenderJobCronTrigger.class.getName());

	public MailSenderJobCronTrigger(String name){
		this.name=name;
		this.group = name+"Group";
	}

	public void run() throws Exception {


        log.info("Initializing");

        // First we must get a reference to a scheduler
        SchedulerFactory sf = new StdSchedulerFactory();


        sched = sf.getScheduler();


        log.info("------- Initialization Complete --------");

        log.info("------- Scheduling Jobs ----------------");

        // jobs can be scheduled before sched.start() has been called

        // job 1 will run every 20 seconds
        JobDetail job = newJob(MailSenderJob.class)
            .withIdentity("MailSenderJob", group)
            .build();

        CronTrigger trigger = newTrigger()
            .withIdentity("trigger1", group)
            //.withSchedule(cronSchedule("* 0/5 * * * ?"))	//초 분 시 일 월 년	(5분마다 계속호출)
            //.withSchedule(cronSchedule("0 0/1 * * * ?"))	//초 분 시 일 월 년	(1분마다 0초에 호출)

           //.withSchedule(cronSchedule("0 0 10,19 * * ?"))	//초 분 시 일 월 년	(오전10,오후7 시마다 job 실행)
           .withSchedule(cronSchedule("0 0 7 * * ?"))	//초 분 시 일 월 년	(오후7 시마다 job 실행)
            .build();

        Date ft = sched.scheduleJob(job, trigger);
        log.debug(job.getKey() + " has been scheduled to run at: " + ft
                + " and repeat based on expression: "
                + trigger.getCronExpression());


        // All of the jobs have been added to the scheduler, but none of the
        // jobs
        // will run until the scheduler has been started
        sched.start();

        log.info("------- Started Scheduler -----------------");


	}

	public void stop()
	{
		try{
			sched.shutdown(true);

			SchedulerMetaData metaData = sched.getMetaData();
	        log.info("Executed " + metaData.getNumberOfJobsExecuted() + " jobs.");


		}catch(Exception e){
			e.printStackTrace();
		}
	}

    public static void main(String[] args) throws Exception {

    	MailSenderJobCronTrigger example = new MailSenderJobCronTrigger("group1");
        example.run();
    }

}
