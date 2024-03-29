<%@ page import="java.io.PrintWriter" %><%--
  Created by IntelliJ IDEA.
  User: ninhn
  Date: 8/2/2021
  Time: 2:56 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix = "sql" uri = "http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib prefix = "x" uri = "http://java.sun.com/jsp/jstl/xml" %>
<%if (session.getAttribute("authentication")==null)
    response.sendRedirect(pageContext.getServletContext().getContextPath()+"/login.jsp");%>
<!DOCTYPE html>
<html>
<head>
    <title><c:out value="${requestScope.quiz_title.toString()}"/></title>
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/icon/quiz.png" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700" rel="stylesheet" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/stylesheet/yui-moodlesimple-min.css"/>
    <script id="firstthemesheet" type="text/css">/** Required in order to fix style inclusion problems in IE with YUI **/</script>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/stylesheet/all.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/stylesheet/newstyle.css">
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/quiz.js"></script>
    <script src="${pageContext.request.contextPath}/js/home.js"></script>
    <script src="${pageContext.request.contextPath}/js/time.js"></script>
</head>
<script>
    var $$ = function( id ) { return document.getElementById( id ); };

    function onflagged(qid) {
        var prefix = $$('112233-page-dynamic-prefix').value;
        let qindex = $$(qid + '_index').value;
        let checkbox  = qid + ':flaggedcheckbox';
        let box = 'quiznavbutton_' + qid;
        let img = qid + ':flaggedimg';
        if ($$(checkbox).checked){
            $$(box).classList.add('flagged');
            $$(img).src =  prefix + '/icon/flagged.svg';
            setFlag(qindex, 'true');
        }
        else{
            $$(box).classList.remove('flagged');
            $$(img).src = prefix + '/icon/unflagged.svg';
            setFlag(qindex, 'false');
        }
    }

    function clearchoice(quesid, box)
    {
        $$(quesid+'answer-1').checked = true;
        $$(quesid+'_clearchoice').hidden = true;
        $$(box+'_img').style.backgroundColor = "rgba(0,189,49,0)";
        let submit_id = 'submit_answer_' + quesid;
        $$(submit_id.toString()).value = "";
        $$('quiznavbutton_' + quesid).title = "Chưa trả lời";
        let qindex = $$(quesid + '_index').value;
        setAnswer(qindex, -1);
    }

    function setClearchoice(quesid,box,ans)
    {
        var prefix = $$('112233-page-dynamic-prefix').value;
        $$(quesid+'_clearchoice').hidden = false;
        var url = prefix + '/icon/checked.png';
        $$(box+'_img').style.backgroundColor = "#95e0f5";
        let ans_id = quesid + 'answer' + ans;
        let submit_id = 'submit_answer_' + quesid;
        $$(submit_id).value = $$(ans_id).value;
        $$('quiznavbutton_' + quesid).title = "Đã trả lời";
        let qindex = $$(quesid + '_index').value;
        setAnswer(qindex, ans);
    }

    function submitQuiz() {
        let isExecuted = confirm("Bạn có chắc là muốn nộp bài hay không?");
        if (isExecuted)
            $$('Quiz-test-submit-form').submit();
    }

    function setAnswer(quesid, ansid){
        var prefix = $$('112233-page-dynamic-prefix').value;
        if (prefix==null) prefix="";
        request_data = {
            question: quesid,
            answer: ansid
        }
        let request = $.ajax({
            url: prefix + '/AnswerAPI',
            type: 'POST',
            dataType: 'text',
            data: request_data
        });
        request.done(function (data) {
            console.log("send answer done!!!");
        });
        request.fail(function (msg){
            //window.alert(msg);
            console.log(msg);
        })
        request.always(function (){
            //console.log("time out: Ajax was call")
        });
    }

    function setFlag(quesid, flag){
        var prefix = $$('112233-page-dynamic-prefix').value;
        if (prefix==null) prefix="";
        request_data = {
            question: quesid,
            flag: flag
        }
        let request = $.ajax({
            url: prefix + '/FlagAPI',
            type: 'POST',
            dataType: 'text',
            data: request_data
        });
        request.done(function (data) {
            console.log("send flag done!!!");
        });
        request.fail(function (msg){
            //window.alert(msg);
            console.log(msg);
        })
        request.always(function (){
            //console.log("time out: Ajax was call")
        });
    }
    function docReady(fn) {
        // see if DOM is already available
        if (document.readyState === "complete" || document.readyState === "interactive") {
            // call on next available tick
            setTimeout(fn, 1);
        } else {
            document.addEventListener("DOMContentLoaded", fn);
        }
    }
</script>
<body  onload="getServerTime()" id="page-mod-quiz-attempt" class="format-topics  path-mod path-mod-quiz chrome dir-ltr lang-vi yui-skin-sam yui3-skin-sam pagelayout-incourse category-81">
<input style="visibility: hidden;" hidden name="dynamic-prefix" value="${pageContext.request.contextPath}" id="112233-page-dynamic-prefix">
<input style="visibility: hidden;" hidden name="TimeStart" value="${requestScope.StartTime}" id="112233-time-start">
<input style="visibility: hidden;" hidden name="TimeLimit" value="${requestScope.LimitTime}" id="112233-time-limit">
<form name="Quiz-test-submit-form" id="Quiz-test-submit-form" hidden method="POST" action="${pageContext.request.contextPath}/Submit">
    <input name="QuizID" value="${requestScope.QuizID}">
    <c:forEach items="${requestScope.mlistQuestion}"  var="ques">
        <input value="" name="<c:out value="${ques.question.id}"/>" id="submit_answer_<c:out value="${ques.question.id}"/>">
    </c:forEach>
</form>
<div class="toast-wrapper mx-auto py-0 fixed-top" role="status" aria-live="polite"></div>
<div id="page-wrapper" class="page-wrapper ">
    <header id="header" class="page-header page-header-top-bar navbar" role="banner">
        <div class="top-bar">
            <div class="container-fluid">
                <div class="top-bar-inner">
                    <div class="special-wrapper navbar">
                        <div class="app-name-main" style="padding-top: -10px;">
                            <img src="${pageContext.request.contextPath}/icon/app-icon.svg" class="app-icon-img">
                            <span class="app-name-text">PHẦN MỀM THI TRẮC NGHIỆM ONLINE</span>
                        </div>
                        <div name="time" class="time-block" hidden>
                            <p name="time" id="server-time-block">00000000000000</p>
                        </div>
                        <div class="utilities">
                            <div class="utilities-inner d-flex align-items-center">
                                <ul class="d-flex usernav p-0 ml-2 mb-0 align-items-center">
                                    <!-- navbar_plugin_output -->
                                    <li class="d-flex mr-3">
                                        <div class="popover-region collapsed popover-region-notifications"
                                             id="nav-notification-popover-container" data-userid="30807"
                                             data-region="popover-region">
                                        </div>
                                    </li>
                                    <!-- user_menu -->
                                    <li class="d-flex">
                                        <div class="usermenu">
                                            <div class="action-menu moodle-actionmenu nowrap-items d-inline" id="action-menu-1" data-enhance="moodle-core-actionmenu">
                                                <div class="menubar d-flex " id="action-menu-1-menubar" role="menubar">
                                                    <div class="action-menu-trigger">
                                                        <div class="dropdown">
                                                            <a href="#" tabindex="0" class="d-inline-block  dropdown-toggle icon-no-margin"
                                                               id="action-menu-toggle-1" aria-label="Thư mục người dùng"
                                                               data-toggle="dropdown" role="button" aria-haspopup="true"
                                                               aria-expanded="false" aria-controls="action-menu-1-menu">
                                                                <span class="userbutton"><span class="usertext mr-1"><c:out value="${requestScope.user_name}"/></span><span class="avatars"><span class="avatar current">
                                                                    <img src="${pageContext.request.contextPath}/icon/profile.png" class="userpicture" width="35" height="35" aria-hidden="true" /></span></span></span>
                                                                <b class="caret"></b>
                                                            </a>
                                                            <div class="dropdown-menu dropdown-menu-right menu  align-tr-br" id="action-menu-1-menu" data-rel="menu-content" aria-labelledby="action-menu-toggle-1" role="menu" data-align="tr-br">
                                                                <a href="${pageContext.request.contextPath}/Home" class="dropdown-item menu-action" role="menuitem" data-title="mymoodle,admin" aria-labelledby="actionmenuaction-1">
                                                                    <i class="icon" aria-hidden="true"  >☖</i>
                                                                    <span class="menu-action-text" id="actionmenuaction-1">Nhà của tôi</span>
                                                                </a>

                                                                <div class="dropdown-divider" role="presentation"><span class="filler">&nbsp;</span></div>

                                                                <a href="${pageContext.request.contextPath}/History" class="dropdown-item menu-action" role="menuitem" data-title="profile,moodle" aria-labelledby="actionmenuaction-2">
                                                                    <i class="icon" aria-hidden="true">✍</i>
                                                                    <span class="menu-action-text" id="actionmenuaction-2">Hồ sơ</span>
                                                                </a>

                                                                <div class="dropdown-divider" role="presentation"><span class="filler">&nbsp;</span></div>

                                                                <a href="#" class="dropdown-item menu-action" role="menuitem" data-title="grades,grades" aria-labelledby="actionmenuaction-3">
                                                                    <i class="icon" aria-hidden="true">❏</i>
                                                                    <span class="menu-action-text" id="actionmenuaction-3">Điểm</span>
                                                                </a>

                                                                <div class="dropdown-divider" role="presentation"><span class="filler">&nbsp;</span></div>

                                                                <a onclick="logout()" class="dropdown-item menu-action" role="menuitem" data-title="logout,moodle" aria-labelledby="actionmenuaction-6">
                                                                    <i class="icon " aria-hidden="true"  >✖</i>
                                                                    <span class="menu-action-text" id="actionmenuaction-6">Thoát</span>
                                                                </a>

                                                                <form id="112233-logout-form" name="logout-form" action="${pageContext.request.contextPath}/Logout" method="POST" hidden></form>

                                                            </div>
                                                        </div>
                                                    </div>
                                                </div></div></div></li>
                                </ul><!--//user-nav-->
                            </div><!--//utilities-inner-->
                        </div><!--//utilities-->
                    </div>
                </div><!--//top-bar-inner-->
            </div>
        </div><!--//top-bar-->
    </header><!--//header-->
    <div class="quiz-time-left-flex">
        <span class="text">Thời gian còn lại: <span class="time" id="time-left-1210">16:04</span></span>
    </div>

    <div class="page-header-wrapper has-course-header-image">
        <div class="container-fluid">
            <header id="page-header" class="row">
                <div class="col-12 pt-3 pb-3">
                    <div class="card ">
                        <div class="card-body ">
                            <div class="d-sm-flex align-items-center">
                                <div class="mr-auto">
                                    <div class="page-context-header"><div class="page-header-headings"><h1><c:out value="${requestScope.quiz_name}"/></h1></div></div>
                                </div>

                                <div class="header-actions-container flex-shrink-0" data-region="header-actions-container">
                                </div>
                            </div>
                            <div class="d-flex flex-wrap">
                                <div id="page-navbar" style="padding-left: 20px;">
                                    <nav aria-label="Thanh điều hướng">Đề thi gồm có <c:out value="${requestScope.no_ques}"/> câu, thời gian thi là <c:out value="${requestScope.time}"/> phút</nav>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </header></div></div><!--//page-header-wrapper-->
    <div id="page" class="container-fluid">
        <div id="page-content" class="row">
            <div id="region-main-box" class="col-12">
                <section id="region-main" class="has-blocks">
                    <div class="card">
                        <div class="card-body">
                            <span class="notifications" id="user-notifications"></span>
                            <div role="main">
                                <span id="maincontent"></span>
                                <div id="quiz-timer-wrapper" class="mb-2">
                                    <div id="quiz-timer" class="quiz-timer-inner py-1 px-2 ml-auto" role="timer" aria-atomic="true" aria-relevant="text">
                                        Thời gian còn lại <span id="quiz-time-left">16:45</span>
                                    </div>
                                    <div class="box py-3 quizaccessnotices" style="visibility: hidden;">
                                        <h3>You can preview this quiz, but if this were a real attempt, you would be blocked because:</h3>
                                        <p>Xin lỗi, trắc nghiệm không thể vào được</p>
                                    </div>
                                </div>
                                <div>
                                <%int ques_id = 1;%>
                                <c:forEach var="ques" items="${requestScope.mlistQuestion}">
                                    <input hidden id="${ques.question.id}_index" value="<%out.print(ques_id-1);%>">
                                    <div id="ques_id${ques.question.id}" class="que multichoice deferredfeedback notyetanswered">
                                        <c:if test="${ques.question.type!=-1}">
                                            <div class="info"><h3 class="no">Câu hỏi <span class="qno"><%out.print(ques_id);%></span></h3>
                                                <div class="state">Chưa trả lời</div>
                                                <div class="grade">Đạt điểm 1,00</div>
                                                <div class="questionflag editable" aria-atomic="true" aria-relevant="text" aria-live="assertive">
                                                    <input type="hidden" name="${ques.question.id}:flagged" value="0" />
                                                    <input type="checkbox" id="${ques.question.id}:flaggedcheckbox" name="${ques.question.id}:flagged" value="1"
                                                           <c:if test="${ques.flagged == true}">checked</c:if>
                                                           onclick="onflagged('${ques.question.id}')" />
                                                    <input type="hidden" value="" class="questionflagpostdata" />
                                                    <label id="${ques.question.id}:flaggedlabel" for="${ques.question.id}:flaggedcheckbox">
                                                        <img src="${pageContext.request.contextPath}/icon/unflagged.svg" alt="Không gắn cờ" class="questionflagimage" id="${ques.question.id}:flaggedimg" />
                                                        <span>Đặt cờ</span>
                                                    </label>
                                                    <c:if test="${ques.flagged == true}">
                                                        <script>
                                                            docReady(function() {
                                                                // DOM is loaded and ready for manipulation here
                                                                onflagged('${ques.question.id}');
                                                            });
                                                        </script>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </c:if>
                                        <div class="content">
                                            <div class="formulation clearfix">
                                                <h4 class="accesshide">Đoạn văn câu hỏi</h4>
                                                <input type="hidden" name="${ques.question.id}:sequencecheck" value="1" />
                                                <div class="qtext"><p id="move_to_this_${ques.question.id}"><c:out escapeXml="false" value="${ques.question.content}"/></p></div>
                                                <div class="ablock">
                                                    <div class="answer">
                                                        <%char ch = 'a';%>
                                                        <c:forEach var="ans" items="${ques.answer}">
                                                            <div class="r0">
                                                                <input type="radio" name="${ques.question.id}answer" value="${ans.content}" <c:if test="${ques.choiced.contentEquals(ans.content)}">checked</c:if>
                                                                       id="${ques.question.id}answer${ans.id}" aria-labelledby="${ques.question.id}answer${ans.id}_label"
                                                                       onclick="setClearchoice('${ques.question.id}','quiznavbutton_<%out.print(ques_id);%>',${ans.id})"/>
                                                                <div class="d-flex w-100" id="${ans.id}answer0_label" data-region="answer-label">
                                                                    <span class="answernumber"><%out.print(ch);%>. </span>
                                                                    <div class="flex-fill ml-1">${ans.content}</div>
                                                                </div>
                                                                <c:if test="${ques.choiced.contentEquals(ans.content)}">
                                                                    <script language="JavaScript">
                                                                        docReady(function() {
                                                                            // DOM is loaded and ready for manipulation here
                                                                            setClearchoice('${ques.question.id}','quiznavbutton_<%out.print(ques_id);%>',${ans.id});
                                                                        });
                                                                    </script>
                                                                </c:if>
                                                            </div>
                                                            <%ch++;%>
                                                        </c:forEach>
                                                    </div>
                                                    <div id="${ques.question.id}_clearchoice" class="qtype_multichoice_clearchoice" hidden="true">
                                                        <input type="radio" name="${ques.question.id}answer" id="${ques.question.id}answer-1" value="-1" class="sr-only" aria-hidden="true">
                                                        <label for="${ques.question.id}answer-1"><a style="color: orange;" tabindex="0" role="button" class="btn btn-link ml-3 mt-n1 mb-n1" onclick="clearchoice('${ques.question.id}','quiznavbutton_<%out.print(ques_id);%>')">Clear my choice</a></label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <c:if test="${ques.question.type!=-1}">
                                        <%ques_id++;%>
                                    </c:if>
                                </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
                <section data-region="blocks-column" class="d-print-none" aria-label="Các khối">
                    <aside id="block-region-side-pre" class="block-region" data-blockregion="side-pre" data-droptarget="1"><a href="#sb-1" class="sr-only sr-only-focusable">Bỏ qua &lt;span id=&quot;mod_quiz_navblock_title&quot;&gt;Bảng câu hỏi&lt;/span&gt;</a>
                        <section id="mod_quiz_navblock"
                                 class=" block block_fake  card mb-3"
                                 role="navigation"
                                 data-block="_fake"
                                 aria-labelledby="instance-fakeid-6106e31164b09-header">
                            <div class="card-body p-3">

                                <h5 id="instance-fakeid-6106e31164b09-header" class="card-title d-inline">
                                    <span id="mod_quiz_navblock_title">Bảng câu hỏi</span>
                                </h5>

                                <div class="card-text content mt-3">

                                    <div class="qn_buttons clearfix multipages">
                                        <%int Qid=1;%>
                                        <c:forEach var="i" begin="1" end="${requestScope.mlistQuestion.size()}" step="1">
                                            <c:if test="${requestScope.mlistQuestion.get(i-1).question.type!=-1}">
                                                <a class="qnbutton notyetanswered free btn thispage" id="quiznavbutton_${requestScope.mlistQuestion.get(i-1).question.id}" title="Chưa trả lời" data-quiz-page="0"
                                                   href="#ques_id${requestScope.mlistQuestion.get(i-1).question.id}">
                                                    <span class="thispageholder"></span>
                                                    <span class="trafficlight" id="quiznavbutton_<%out.print(Qid);%>_img"></span>
                                                    <span class="accesshide">Question </span> <%out.print(Qid);%>
                                                    <span class="accesshide"> This page <span class="flagstate"></span></span>
                                                </a>
                                                <%Qid++;%>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                    <div class="othernav">
                                        <div class="singlebutton">
                                            <button class="btn btn-secondary"
                                                    id="single_button6106e311627ef3"
                                                    onclick="submitQuiz()"
                                                    title="">Nộp và kết thúc bài làm</button>
                                        </div>
                                    </div>
                                    <div class="footer"></div>

                                </div>
                            </div>
                        </section>
                        <span id="sb-1"></span></aside>
                </section>
            </div>
        </div>
    </div>
    <footer id="page-footer" class="page-footer">
        <div class="footer-bottom-bar">
            <small class="copyright">Copyright Nguyen Quoc Ninh © 2021</small>
        </div>
    </footer>
</div>
</body>
</html>