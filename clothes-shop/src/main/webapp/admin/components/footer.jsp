<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!-- Page footer -->
    <footer class="footer footer-transparent d-print-none">
        <div class="container-xl">
            <div class="row text-center align-items-center">
                <div class="col-12">
                    <ul class="list-inline list-inline-dots mb-0">
                        <li class="list-inline-item">
                            &copy; 2026 <a href="." class="link-secondary">Clothes Shop</a>. All rights reserved.
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </footer>
    </div><!-- /.page-wrapper -->
    </div><!-- /.page -->
    <script src="https://cdn.jsdelivr.net/npm/@tabler/core@latest/dist/js/tabler.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script>
        $(document).ready(function () {
            $('.select2-search').select2({
                width: '100%',
                language: {
                    noResults: function () {
                        return "Không tìm thấy kết quả";
                    }
                }
            });
        });
    </script>
    </body>
</html>