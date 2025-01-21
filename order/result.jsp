<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>

<%@ include file="/WEB-INF/views/include/head.jsp" %>

<script type="text/javascript">
$(function(){
   
   if(icia.common.type(window.opener) == "object")
   {
      if(icia.common.type(window.opener.fn_kakaoPayResult) == "function")
      {
         window.opener.fn_kakaoPayResult(${code}, "${msg}", "${orderId}");
      }
      else
      {
    	  Swal.fire({
      		position: "center", 
      		title: "${msg}", 
      		showConfirmButton: false, 
      		timer: 1500 
      		});

         window.close();
      }
   }
   else
   {
	   Swal.fire({
     		position: "center", 
     		title: "${msg}", 
     		showConfirmButton: false, 
     		timer: 1500 
     		});
      window.close();
   }
   
});
</script>
</head>
<body>

</body>
</html>