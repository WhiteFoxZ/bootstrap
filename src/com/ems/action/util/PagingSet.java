package com.ems.action.util;

public class PagingSet {
	private int totalCount;  //총게시물수
	private int currentPage=1;  //현재 페이지
	private int blockCount=10;  // 한페이지당 게시물수
	private int blockPage=10;  //블럭수
	private String pagingHtml;  //페이징을 구현한 HTML
	
	public int getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	public int getCurrentPage() {
		return currentPage;
	}
	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
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
	public String getPagingHtml() {
		return pagingHtml;
	}
	public void setPagingHtml(String pagingHtml) {
		this.pagingHtml = pagingHtml;
	}
	public PagingAction getPage() {
		return page;
	}
	public void setPage(PagingAction page) {
		this.page = page;
	}
	private PagingAction page;  //페이징 클래스
}
