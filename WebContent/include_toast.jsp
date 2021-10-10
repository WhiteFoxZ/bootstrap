<%@ page   pageEncoding="UTF-8"%>
      <!-- Custom CSS -->

   <script>

   var toastMsg;

   function toastInit(){
       var option= {
               animation: true,
               autohide: true,
               delay: 2000
             }

         toastMsg = new bootstrap.Toast($("#toastMsg"), option);

   }

   function showMsg(msgText){

       $(".toast-body").text(msgText);
       toastMsg.show();

   }


   function hideMsg(){
     toastMsg.hide();
   }


   </script>

<!-- toastMsg  -->
<div aria-live="polite" aria-atomic="true"  class="position-fixed end-0 start-0 p-3" style="display: flex; justify-content: center;"   id="toastPlacement">
<!-- toast show hide -->
<div id="toastMsg" class="toast" role="alert" aria-live="assertive" aria-atomic="true" >
 <div class="toast-header">
   <strong class="me-auto">알림</strong>
   <!-- <small>11 mins ago</small> -->
   <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
 </div>
 <div class="toast-body">
   Hello, world! This is a toast message.
 </div>
</div>
</div>
<!-- toastMsg  -->

