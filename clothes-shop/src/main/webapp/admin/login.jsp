<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>

    <title>Admin Login - Clothes Shop</title>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/@tabler/core@latest/dist/css/tabler.min.css"/>

    <style>
        :root {
            --primary: #206bc4;
            --dark-bg: #0f172a;
            --card-bg: rgba(15, 23, 42, 0.8);
            --border: rgba(255,255,255,.08);
        }

        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
        }

        body{
            min-height:100vh;
            display:flex;
            justify-content:center;
            align-items:center;
            overflow:hidden;
            background:#0f172a;
            position:relative;
            font-family:Inter,sans-serif;
        }

        /* Grid Background */
        body::before{
            content:"";
            position:absolute;
            inset:0;

            background-image:
                    linear-gradient(rgba(255,255,255,.04) 1px, transparent 1px),
                    linear-gradient(90deg, rgba(255,255,255,.04) 1px, transparent 1px);

            background-size:40px 40px;

            mask-image:linear-gradient(
                    to bottom,
                    transparent,
                    rgba(0,0,0,.8),
                    black
            );
        }

        /* Blue Glow */
        body::after{
            content:"";
            position:absolute;
            width:700px;
            height:700px;

            left:50%;
            bottom:-350px;
            transform:translateX(-50%);

            background:radial-gradient(
                    circle,
                    rgba(32,107,196,.45),
                    transparent 70%
            );

            filter:blur(80px);
        }

        .login-card{
            position:relative;
            z-index:10;

            width:100%;
            max-width:450px;

            background:var(--card-bg);
            backdrop-filter:blur(20px);

            border-radius:24px;
            border:1px solid var(--border);

            box-shadow:
                    0 20px 60px rgba(0,0,0,.5),
                    0 0 50px rgba(32,107,196,.12);
        }

        .login-card::before{
            content:"";
            position:absolute;
            inset:0;

            border-radius:24px;
            padding:1px;

            background:
                    linear-gradient(
                            135deg,
                            rgba(255,255,255,.18),
                            transparent,
                            rgba(32,107,196,.3)
                    );

            -webkit-mask:
                    linear-gradient(#fff 0 0) content-box,
                    linear-gradient(#fff 0 0);

            -webkit-mask-composite:xor;
            mask-composite:exclude;
        }

        .card-body{
            padding:40px !important;
        }

        .login-brand{
            text-align:center;
            margin-bottom:2rem;
        }

        .logo-box{
            width:80px;
            height:80px;
            margin:auto;
            margin-bottom:18px;

            display:flex;
            align-items:center;
            justify-content:center;

            border-radius:20px;

            background:
                    linear-gradient(
                            135deg,
                            #206bc4,
                            #3b82f6
                    );

            box-shadow:
                    0 0 25px rgba(59,130,246,.4);
        }

        .login-brand h2{
            color:white;
            font-weight:700;
            letter-spacing:1px;
            margin-bottom:4px;
        }

        .login-brand p{
            color:#94a3b8;
            margin:0;
        }

        .form-label{
            color:#cbd5e1;
            font-weight:600;
        }

        .form-control{
            background:rgba(255,255,255,.05);
            border:1px solid rgba(255,255,255,.08);
            color:white;
        }

        .form-control::placeholder{
            color:#64748b;
        }

        .form-control:focus{
            background:rgba(255,255,255,.08);
            border-color:#206bc4;
            color:white;

            box-shadow:
                    0 0 0 .25rem rgba(32,107,196,.2);
        }

        .input-icon-addon{
            background:transparent;
            color:#94a3b8;
        }

        .btn-login{
            height:50px;
            border:none;

            font-size:15px;
            font-weight:600;
            letter-spacing:.5px;

            background:
                    linear-gradient(
                            135deg,
                            #206bc4,
                            #3b82f6
                    );

            transition:.3s;
        }

        .btn-login:hover{
            transform:translateY(-2px);

            box-shadow:
                    0 10px 30px rgba(59,130,246,.45);
        }

        .alert-danger{
            background:rgba(220,38,38,.12);
            border:1px solid rgba(220,38,38,.25);
            color:#fecaca;
        }

        .copyright{
            text-align:center;
            color:#64748b;
            font-size:13px;
            margin-top:24px;
        }
    </style>
</head>

<body>

<div class="card login-card">

    <div class="card-body">

        <div class="login-brand">

            <div class="logo-box">
                <svg xmlns="http://www.w3.org/2000/svg"
                     width="36"
                     height="36"
                     viewBox="0 0 24 24"
                     fill="none"
                     stroke="white"
                     stroke-width="2">

                    <path d="M6 2l6 4l6-4v6l-6 4l-6-4z"/>
                    <path d="M6 8v8l6 4l6-4V8"/>

                </svg>
            </div>

            <h2>CLOTHES SHOP</h2>
            <p>Administration Panel</p>

        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger mb-4">
                ${error}
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <form action="${ctx}/admin/login"
              method="post"
              autocomplete="off">

            <div class="mb-4">

                <label class="form-label">
                    Tên đăng nhập
                </label>

                <div class="input-icon">

                    <span class="input-icon-addon">

                        <svg xmlns="http://www.w3.org/2000/svg"
                             class="icon"
                             width="24"
                             height="24"
                             viewBox="0 0 24 24"
                             stroke-width="2"
                             stroke="currentColor"
                             fill="none">

                            <circle cx="12" cy="7" r="4"/>
                            <path d="M6 21v-2a4 4 0 0 1 4-4h4a4 4 0 0 1 4 4v2"/>

                        </svg>

                    </span>

                    <input type="text"
                           class="form-control"
                           name="username"
                           placeholder="Nhập tên đăng nhập"
                           value="${inputUsername}"
                           required
                           autofocus/>

                </div>

            </div>

            <div class="mb-4">

                <label class="form-label">
                    Mật khẩu
                </label>

                <div class="input-icon">

                    <span class="input-icon-addon">

                        <svg xmlns="http://www.w3.org/2000/svg"
                             class="icon"
                             width="24"
                             height="24"
                             viewBox="0 0 24 24"
                             stroke-width="2"
                             stroke="currentColor"
                             fill="none">

                            <rect x="5" y="11" width="14" height="10" rx="2"/>
                            <path d="M8 11v-4a4 4 0 0 1 8 0v4"/>

                        </svg>

                    </span>

                    <input type="password"
                           class="form-control"
                           name="password"
                           placeholder="Nhập mật khẩu"
                           required/>

                </div>

            </div>

            <button type="submit"
                    class="btn btn-primary btn-login w-100">

                Đăng nhập hệ thống

            </button>

        </form>

        <div class="copyright">
            © 2026 Clothes Shop Admin
        </div>

    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/@tabler/core@latest/dist/js/tabler.min.js"></script>

</body>
</html>