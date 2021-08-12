package com.ems.action.util;


public class PagingAction {
	
	private int currentPage;  
	private int totalCount;   
	private int totalPage;   
	private int blockCount;   
	private int blockPage;   
	private int startCount; 
	private int endCount;   
	private int startPage;   
	private int endPage;     
	private StringBuffer pagingHtml; 
  
	private org.apache.log4j.Logger log = org.apache.log4j.Logger.getLogger( this.getClass() );
	 

	
	
	public PagingAction(int cp,int tc,int bc,int bp,int id ,String db ){
		this.currentPage=cp;
		this.totalCount=tc;
		this.blockCount=bc;
		this.blockPage=bp;
		
		totalPage=(int)Math.ceil((double)totalCount/blockCount);
		if(totalPage==0){
			totalPage=1;
		}
	
		if(currentPage>totalPage){
			currentPage=totalPage;    
		}
		
		startCount=(currentPage-1)*blockCount+1;
		endCount=startCount+blockCount-1;
    
		startPage=(int)((currentPage-1)/blockPage)*blockPage+1;
		endPage=startPage+blockPage-1;
    
		if(endPage>totalPage){
			endPage=totalPage;
		}
		
		
    
  
    log.debug("\n################################");
    log.debug("# currentPage " + this.currentPage );
    log.debug("# totalCount " + totalCount );
    log.debug("# blockCount " + blockCount );
    log.debug("# blockPage " + blockPage );
    log.debug("# startCount " + startCount );
    log.debug("# endCount " + endCount );
    log.debug("# startPage " + startPage );
    log.debug("# endPage " + endPage );    
    log.debug("# totalPage " + totalPage );    
    
    log.debug("\n################################");
    
    
		
	}

	public int getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}

	public int getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}

	public int getBlockCount() {
		return blockCount;
	}

	public void setBlockCount(int blockCount) {
		this.blockCount = blockCount;
	}

	public int getBlockPage() {
		return blockPage;
	}

	public void setBlockPage(int blockPage) {
		this.blockPage = blockPage;
	}

	public int getStartCount() {
		return startCount;
	}

	public void setStartCount(int startCount) {
		this.startCount = startCount;
	}

	public int getEndCount() {
		return endCount;
	}

	public void setEndCount(int endCount) {
		this.endCount = endCount;
	}

	public int getStartPage() {
		return startPage;
	}

	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}

	public int getEndPage() {
		return endPage;
	}

	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}

	public StringBuffer getPagingHtml() {
    pagingHtml=new StringBuffer();
		
		if(currentPage>blockPage){
//			pagingHtml.append("<a href=/board/list.do?id="+id+"&db="+db+"&currentPage="+(startPage-1)+">");
      pagingHtml.append("<a href='javascript:setPage(").append((startPage-1)).append(");'>");
			pagingHtml.append("[이전]");
			pagingHtml.append("</a>");
		}
		
		pagingHtml.append("&nbsp;&nbsp;");
				
		for(int i=startPage;i<=endPage;i++){
			if(i>totalPage){break;}
			if(i==currentPage){
				pagingHtml.append("&nbsp;<b><font color='red'>");
				pagingHtml.append("["+i+"]");
				pagingHtml.append("</font></b>");
			}else{
//				pagingHtml.append("<a href=/board/list.do?id="+id+"&db="+db+"&currentPage="+i+">");
        pagingHtml.append("<a href='javascript:setPage(").append(i).append(");'>");
				pagingHtml.append("["+i+"]");
				pagingHtml.append("</a>");
			}
			pagingHtml.append("&nbsp;");
		}
    
    if(totalPage!=endPage)
    {
      pagingHtml.append("<a href='javascript:setPage(").append(totalPage).append(");'>...[").append(totalPage).append("]</a>");
    }
		pagingHtml.append("&nbsp;&nbsp;");
		
    
		if((totalPage-startPage)>=blockPage){
//			pagingHtml.append("<a href=/board/list.do?id="+id+"&db="+db+"&currentPage="+(endPage+1)+">");
      pagingHtml.append("<a href='javascript:setPage(").append((endPage+1)).append(");'>");
			pagingHtml.append("[다음]");
			pagingHtml.append("</a>");
			
		}
    
		return pagingHtml;
	}

	public void setPagingHtml(StringBuffer pagingHtml) {
		this.pagingHtml = pagingHtml;
	}
  
  public int getNextPage()
  { 
    int nextPage=currentPage;
    
    if(currentPage<endPage) nextPage=currentPage+1;
    return nextPage;
  }
  
  public int getPrevPage()
  {
    int prevPage=currentPage;
    
    if(currentPage>1) prevPage=currentPage-1;
    return prevPage;
  }
  




}//end_class
