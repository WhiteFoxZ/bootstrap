
/**
 * 화면에 첨부파일 기능을 활성화 한다.
 */
function attach_file_init(){	
	
	/*jQuery form 플러그인을 사용하여 폼데이터를 ajax로 전송*/
	//폼전송 : 해당폼의 submit 이벤트가 발생했을경우 실행  
    $('#multiform').ajaxForm({
       cache: false,
       dataType:"json",
       //보내기전 validation check가 필요할경우
       beforeSubmit: function (data, frm, opt) {
	       console.log(data);
	       console.log(frm);
	       
	       
           var len1 = $('div.attach').length;	//첨부된 이미지 파일갯수
           var len2 = $('div.MultiFile-label').length; //첨부파일 목록갯수
                      
           if( attach_file_cnt < (len1 + len2) ){
        	   
        	   alert('업로드 최대 갯수는 '+ attach_file_cnt +'입니다.');

        	   return false;
           }
           
           
           return true;
       },
       //submit이후의 처리
       success: function(data, statusText){
    	   
    	   //alert("전송성공!!");
           console.log(data); //응답받은 데이터 콘솔로 출력         
           
           output(data); //받은 정보를 화면 출력하는 함수 호출
       },
       //ajax error
       error: function(e){
           alert("에러발생!!");
           console.log(e);
       }                               
	});	
	
	//use jQuery MultiFile Plugin 
	$('#multiform input[name=photo]').MultiFile({
		max: attach_file_cnt, //업로드 최대 파일 갯수 (지정하지 않으면 무한대)
		accept: attach_file_ext, //허용할 확장자(지정하지 않으면 모든 확장자 허용)
		maxfile: 512, //각 파일 최대 업로드 크기
		maxsize: 1024,  //전체 파일 최대 업로드 크기
		STRING: { //Multi-lingual support : 메시지 수정 가능
		    remove : "제거", //추가한 파일 제거 문구, 이미태그를 사용하면 이미지사용가능
		    duplicate : "$file 은 이미 선택된 파일입니다.", 
		    denied : "$ext 는(은) 업로드 할수 없는 파일확장자입니다.",
		     selected:'$file 을 선택했습니다.', 
		    toomuch: "업로드할 수 있는 최대크기를 초과하였습니다.($size)", 
		    toomany: "업로드할 수 있는 최대 갯수는 $max개 입니다.",
		    toobig: "$file 은 크기가 매우 큽니다. (max $size)"
		},
		list:"#afile3-list" //파일목록을 출력할 요소 지정가능
	});
}	



/**
첨부파일이 있을경우 화면에 보여준다
**/
function viewAttachFileJson(pk){
		
	//첨부파일 시작 					 
 	var actionUrl ="FileViewServlet?PK_IMG="+pk+"&TNAME="+tname;
 	
 	var returnVal=null;

	$.ajax({
		type : 'get',
		dataType : "json", //json 아닐때 제거
		async: false ,
		
		data : {			
		},
		
		url : actionUrl,
		success : function(result) { //json 형태의 값( key,value)												
			
			returnVal =  result;

		},
		complete : function(data) {
			//log(data);
			//alert('complete');
		},
		error : function(xhr, status, error) {
			//log(error);
			alert('error');
		}

	});
	//첨부파일끝
	
	return returnVal;
							
}


/**
첨부파일이 있을경우 화면에 보여준다
**/
function viewAttachFile(pk){
			        
    //첨부파일 정보를 리셋        
	var ATTACH_FILE_ID = $("#ATTACH_FILE_ID");
	
	$('div.attach').each(function(idx,element){
					
		$(element).remove();
		
	});
	
	ATTACH_FILE_ID.val("");
	
	//첨부파일 정보를 리셋
	
	
	//첨부파일 시작 					 
 	var actionUrl ="FileViewServlet?PK_IMG="+pk+"&TNAME="+tname;			

	$.ajax({
		type : 'get',
		dataType : "json", //json 아닐때 제거
		async: false ,
		
		data : {			
		},
		
		url : actionUrl,
		success : function(result) { //json 형태의 값( key,value)												
			
			output(result);

		},
		complete : function(data) {
			//log(data);
			//alert('complete');
		},
		error : function(xhr, status, error) {
			//log(error);
			alert('error');
		}

	});
	//첨부파일끝
							
}

function removeAttach(id){	
	
	 //alert($("#result").html());
	 
	 var actionUrl ="FileDeleteServlet?PK_IMG="+id;
	 

		$.ajax({
			type : 'get',
			dataType : "json", //json 아닐때 제거
			async: false ,
			
			data : {			
			},
			
			url : actionUrl,
			success : function(result) { //json 형태의 값( key,value)
					
				if (result.event == 'success') {
					//이미지를 삭제한다.																		
					var s = $("#"+id);
					s.remove();								 					 
				} else {
					alert('삭제할대상이 없습니다.');
				}

			},
			complete : function(data) {
				//log(data);
				
			},
			error : function(xhr, status, error) {
				//log(error);
				alert('error');
			}

		});
		

}

//전달받은 정보를 가지고 화면에 보기 좋게 출력(이미지 이면 화면에 보여주고 파일이면 따운로드 하도록 변경)
function output(data) {
	
	//alert(JSON.stringify(data) );
	
	//업로드한 파일을 다운로드할수있도록 화면 구성
		    
    if(data.photo){
                
        $.each(data.photo, function(index, item){
        				        	
     	  var link = "<a href='FileDownload?PK_IMG="+item.uploadedFileName +"' >"+item.fileName+"</a>";
     	   
     	  var link2 = "<img src='DisplayImage?PK_IMG="+item.uploadedFileName +"' />" ; 
       	   
     	  if(item.contentType=="image/jpeg"){    
     		  
     		var link3 = "<div id='"+item.uploadedFileName+"' class='attach' >"+"<input type='button' id='remove' onclick='removeAttach("+item.uploadedFileName+")' value='삭제'>&nbsp;"+link2+"</div>";
        	       
     		$("#result").append(link3);
     		          
     	  }else{
     		  
     		 var link3 = "<div id='"+item.uploadedFileName+"' class='attach' >"+"<input type='button' id='remove' onclick='removeAttach("+item.uploadedFileName+")' value='삭제'>&nbsp;"+link+"</div>";
         
     		$("#result").append(link3);
                             
     	  }

        });
        
        
    }
    
    $('#multiform')[0].reset(); //폼 초기화(리셋); 
    $('#multiform input:file').MultiFile('reset'); //멀티파일 초기화        
}


//첨부파일을 화면에서 삭제한다.
function resetAttach(){
	
	$('div.attach').each(function(idx,element){
		
		$(element).remove();
		
	});
		
}

/**
 * 첨부파일에 파일 번호를 추출한다.
 */
function beforeSave(){
	
	var ATTACH_FILE_ID = $("#ATTACH_FILE_ID");
	
	var str_id="";
	
	$('div.attach').each(function(idx,element){
		
		str_id = str_id + $(element).attr("id")+",";
		
	});
	
	ATTACH_FILE_ID.val(str_id);
	
	alert(str_id);
							
}

