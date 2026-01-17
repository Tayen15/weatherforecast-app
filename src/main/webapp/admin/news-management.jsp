<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Berita - WeatherNow</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdn.tiny.cloud/1/z72nwuco4n4dl82wa73wr87z45kfsvdnlsiqaj14wwc004gc/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>
    <style>
        * { font-family: 'Inter', sans-serif; }
        body { background: #0f172a; min-height: 100vh; }
        .glass-card {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .bento-card {
            background: rgba(30, 41, 59, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.6);
            animation: fadeIn 0.3s;
        }
        .modal.active {
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .modal-content {
            background-color: #fefefe;
            padding: 0;
            border-radius: 16px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            width: 90%;
            max-width: 800px;
            max-height: 90vh;
            overflow-y: auto;
            animation: slideIn 0.3s;
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        @keyframes slideIn {
            from { transform: translateY(-50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        /* Toast Notification Styles */
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .toast {
            padding: 16px 20px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            gap: 12px;
            min-width: 300px;
            max-width: 450px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            animation: toastSlideIn 0.4s ease-out;
            position: relative;
        }
        .toast.hiding {
            animation: toastSlideOut 0.3s ease-in forwards;
        }
        .toast-success {
            background: #10b981;
            color: white;
        }
        .toast-error {
            background: #ef4444;
            color: white;
        }
        .toast-warning {
            background: #f59e0b;
            color: white;
        }
        .toast-info {
            background: #0ea5e9;
            color: white;
        }
        .toast-icon {
            font-size: 1.25rem;
        }
        .toast-message {
            flex: 1;
            font-weight: 500;
        }
        .toast-close {
            background: none;
            border: none;
            color: white;
            opacity: 0.8;
            cursor: pointer;
            padding: 4px;
            font-size: 1rem;
            transition: opacity 0.2s;
        }
        .toast-close:hover {
            opacity: 1;
        }
        .toast-progress {
            position: absolute;
            bottom: 0;
            left: 0;
            height: 4px;
            background: rgba(255, 255, 255, 0.4);
            border-radius: 0 0 12px 12px;
            animation: progressShrink 4s linear forwards;
        }
        @keyframes toastSlideIn {
            from { 
                transform: translateX(100%);
                opacity: 0;
            }
            to { 
                transform: translateX(0);
                opacity: 1;
            }
        }
        @keyframes toastSlideOut {
            from { 
                transform: translateX(0);
                opacity: 1;
            }
            to { 
                transform: translateX(100%);
                opacity: 0;
            }
        }
        @keyframes progressShrink {
            from { width: 100%; }
            to { width: 0%; }
        }
    </style>
</head>
<body>
    <!-- Toast Container -->
    <div id="toastContainer" class="toast-container"></div>
    
    <jsp:include page="../includes/navbar.jsp" />
    
    <main class="container mx-auto px-4 py-8">
        <div class="glass-card rounded-2xl shadow-xl p-8">
            <!-- Header -->
            <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-8">
                <div>
                    <h1 class="text-3xl font-bold text-gray-800 flex items-center">
                        <div class="w-12 h-12 bg-sky-100 rounded-xl flex items-center justify-center mr-4">
                            <i class="fas fa-newspaper text-sky-500 text-xl"></i>
                        </div>
                        Kelola Berita
                    </h1>
                    <p class="text-gray-500 mt-2 ml-16">Tambah, edit, dan kelola konten berita</p>
                </div>
                <button onclick="openModal()" class="bg-sky-600 hover:bg-sky-700 text-white px-6 py-3 rounded-xl font-semibold transition shadow-lg shadow-sky-600/30">
                    <i class="fas fa-plus mr-2"></i>Tambah Berita
                </button>
            </div>
            
            <!-- Search Bar -->
            <div class="mb-6">
                <div class="relative">
                    <input type="text" id="searchInput" placeholder="Cari berita berdasarkan judul atau konten..." 
                           class="w-full px-5 py-3.5 pl-12 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-sky-500 focus:border-transparent bg-gray-50">
                    <i class="fas fa-search absolute left-4 top-4 text-gray-400"></i>
                </div>
            </div>
            
            <!-- News Table -->
            <div class="overflow-x-auto rounded-xl border border-gray-200">
                <table class="min-w-full">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">ID</th>
                            <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Judul</th>
                            <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Penulis</th>
                            <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Status</th>
                            <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Tanggal</th>
                            <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Aksi</th>
                        </tr>
                    </thead>
                    <tbody id="newsTableBody" class="bg-white divide-y divide-gray-100">
                        <!-- Will be populated by JavaScript -->
                    </tbody>
                </table>
            </div>
            
            <!-- Pagination -->
            <div id="pagination" class="mt-6 flex justify-center items-center space-x-2">
                <!-- Will be populated by JavaScript -->
            </div>
        </div>
    </main>
    
    <!-- Modal Dialog for Create/Edit -->
    <div id="newsModal" class="modal">
        <div class="modal-content">
            <div class="bg-sky-600 text-white px-6 py-5 rounded-t-2xl flex justify-between items-center">
                <h2 id="modalTitle" class="text-xl font-bold">Tambah Berita</h2>
                <button onclick="closeModal()" class="text-white hover:text-gray-200 w-10 h-10 flex items-center justify-center rounded-lg hover:bg-white/10 transition">
                    <i class="fas fa-times text-xl"></i>
                </button>
            </div>
            <form id="newsForm" class="p-6">
                <input type="hidden" id="newsId" name="id">
                
                <div class="mb-5">
                    <label for="title" class="block text-gray-700 font-semibold mb-2">Judul Berita*</label>
                    <input type="text" id="title" name="title" required
                           class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-sky-500 focus:border-transparent"
                           placeholder="Masukkan judul berita">
                </div>
                
                <div class="mb-5">
                    <label for="author" class="block text-gray-700 font-semibold mb-2">Penulis*</label>
                    <input type="text" id="author" name="author" required
                           class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-sky-500 focus:border-transparent"
                           placeholder="Masukkan nama penulis">
                </div>
                
                <div class="mb-5">
                    <label for="imageUrl" class="block text-gray-700 font-semibold mb-2">URL Gambar</label>
                    <input type="url" id="imageUrl" name="imageUrl"
                           class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-sky-500 focus:border-transparent"
                           placeholder="https://example.com/image.jpg (opsional)">
                    <p class="text-sm text-gray-400 mt-2">Kosongkan untuk menggunakan gambar placeholder</p>
                </div>
                
                <div class="mb-5">
                    <label for="content" class="block text-gray-700 font-semibold mb-2">Konten Berita*</label>
                    <textarea id="content" name="content" rows="10" required
                              class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-sky-500 focus:border-transparent">
                    </textarea>
                </div>
                
                <div class="mb-6">
                    <label class="flex items-center cursor-pointer">
                        <input type="checkbox" id="isPublished" name="isPublished" class="mr-3 h-5 w-5 text-sky-600 rounded focus:ring-sky-500">
                        <span class="text-gray-700 font-medium">Publikasikan berita ini</span>
                    </label>
                </div>
                
                <div class="flex justify-end space-x-3">
                    <button type="button" onclick="closeModal()" 
                            class="px-6 py-3 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded-xl font-medium transition">
                        Batal
                    </button>
                    <button type="submit" 
                            class="px-6 py-3 bg-sky-600 hover:bg-sky-700 text-white rounded-xl font-medium transition shadow-lg shadow-sky-600/30">
                        <i class="fas fa-save mr-2"></i>Simpan
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content" style="max-width: 420px;">
            <div class="bg-red-500 text-white px-6 py-5 rounded-t-2xl">
                <h2 class="text-xl font-bold flex items-center">
                    <i class="fas fa-exclamation-triangle mr-3"></i>Konfirmasi Hapus
                </h2>
            </div>
            <div class="p-6">
                <p class="text-gray-600 mb-6">Apakah Anda yakin ingin menghapus berita ini? Tindakan ini tidak dapat dibatalkan.</p>
                <div class="flex justify-end space-x-3">
                    <button onclick="closeDeleteModal()" 
                            class="px-6 py-3 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded-xl font-medium transition">
                        Batal
                    </button>
                    <button onclick="confirmDelete()" 
                            class="px-6 py-3 bg-red-500 hover:bg-red-600 text-white rounded-xl font-medium transition">
                        <i class="fas fa-trash mr-2"></i>Hapus
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../includes/footer.jsp" />
    
    <script>
        // ========================================
        // GLOBAL VARIABLES
        // ========================================
        let currentPage = 1;           // Current pagination page
        let currentSearch = '';        // Current search query
        let deleteNewsId = null;       // ID of news to be deleted
        let editor = null;             // TinyMCE editor instance
        
        // ========================================
        // INITIALIZATION
        // ========================================
        
        /**
         * Initialize application when DOM is ready
         * - Sets up TinyMCE rich text editor
         * - Loads initial news list
         * - Configures search functionality with debounce
         */
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize TinyMCE rich text editor
            tinymce.init({
                selector: '#content',
                height: 400,
                menubar: false,
                plugins: [
                    'advlist', 'autolink', 'lists', 'link', 'image', 'charmap', 'preview',
                    'anchor', 'searchreplace', 'visualblocks', 'code', 'fullscreen',
                    'insertdatetime', 'media', 'table', 'help', 'wordcount'
                ],
                toolbar: 'undo redo | blocks | bold italic forecolor | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | removeformat | help',
                content_style: 'body { font-family:Helvetica,Arial,sans-serif; font-size:14px }'
            });
            
            // Load initial news list
            loadNews();
            
            // Setup search functionality with debounce (500ms delay)
            let searchTimeout;
            document.getElementById('searchInput').addEventListener('input', function(e) {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    currentSearch = e.target.value;
                    currentPage = 1; // Reset to first page on new search
                    loadNews();
                }, 500);
            });
        });
        
        // ========================================
        // API CONFIGURATION
        // ========================================
        
        // Get application context path for building URLs
        const contextPath = '<%= request.getContextPath() %>';
        
        // ========================================
        // NEWS DATA OPERATIONS
        // ========================================
        
        /**
         * Loads news list from server with pagination and search
         * Displays results in table and updates pagination controls
         */
        function loadNews() {
            const url = contextPath + '/admin/news?action=list&page=' + currentPage + 
                        (currentSearch ? '&search=' + encodeURIComponent(currentSearch) : '');
            
            fetch(url, { credentials: 'same-origin' })
                .then(response => {
                    // Validate response is JSON (not HTML redirect)
                    if (!response.ok || !response.headers.get('content-type')?.includes('application/json')) {
                        throw new Error('Session expired');
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        displayNews(data.data);
                        displayPagination(data.totalPages, data.currentPage);
                    } else {
                        showToast(data.message, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    if (error.message === 'Session expired') {
                        window.location.href = contextPath + '/login.jsp?error=session_expired';
                    } else {
                        showToast('Terjadi kesalahan saat memuat data', 'error');
                    }
                });
        }
        
        /**
         * Displays news list in the table
         * @param {Array} newsList - Array of news objects
         */
        function displayNews(newsList) {
            const tbody = document.getElementById('newsTableBody');
            tbody.innerHTML = '';
            
            if (newsList.length === 0) {
                tbody.innerHTML = '<tr><td colspan="6" class="px-6 py-4 text-center text-gray-500">Tidak ada data</td></tr>';
                return;
            }
            
            newsList.forEach(news => {
                const row = document.createElement('tr');
                
                const statusClass = news.isPublished ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800';
                const statusText = news.isPublished ? 'Dipublikasikan' : 'Draft';
                const toggleClass = news.isPublished ? 'text-yellow-600 hover:text-yellow-900' : 'text-green-600 hover:text-green-900';
                const toggleTitle = news.isPublished ? 'Ubah ke Draft' : 'Publikasikan';
                const toggleIcon = news.isPublished ? 'fa-eye-slash' : 'fa-eye';
                
                row.innerHTML = 
                    '<td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">' + news.id + '</td>' +
                    '<td class="px-6 py-4 text-sm text-gray-900">' + escapeHtml(news.title) + '</td>' +
                    '<td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">' + escapeHtml(news.author) + '</td>' +
                    '<td class="px-6 py-4 whitespace-nowrap">' +
                        '<span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full ' + statusClass + '">' +
                            statusText +
                        '</span>' +
                    '</td>' +
                    '<td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">' + formatDate(news.createdAt) + '</td>' +
                    '<td class="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">' +
                        '<button onclick="editNews(' + news.id + ')" class="text-blue-600 hover:text-blue-900" title="Edit">' +
                            '<i class="fas fa-edit"></i>' +
                        '</button>' +
                        '<button onclick="togglePublish(' + news.id + ', ' + news.isPublished + ')" ' +
                                'class="' + toggleClass + '" ' +
                                'title="' + toggleTitle + '">' +
                            '<i class="fas ' + toggleIcon + '"></i>' +
                        '</button>' +
                        '<button onclick="deleteNews(' + news.id + ')" class="text-red-600 hover:text-red-900" title="Hapus">' +
                            '<i class="fas fa-trash"></i>' +
                        '</button>' +
                    '</td>';
                tbody.appendChild(row);
            });
        }
        
        // Display pagination
        function displayPagination(totalPages, currentPageNum) {
            const pagination = document.getElementById('pagination');
            pagination.innerHTML = '';
            
            if (totalPages <= 1) return;
            
            // Previous button
            if (currentPageNum > 1) {
                const prev = document.createElement('button');
                prev.innerHTML = '<i class="fas fa-chevron-left"></i>';
                prev.className = 'px-3 py-2 bg-white border border-gray-300 rounded-lg hover:bg-gray-100';
                prev.onclick = () => { currentPage--; loadNews(); };
                pagination.appendChild(prev);
            }
            
            // Page numbers
            for (let i = 1; i <= totalPages; i++) {
                if (i === 1 || i === totalPages || (i >= currentPageNum - 2 && i <= currentPageNum + 2)) {
                    const btn = document.createElement('button');
                    btn.textContent = i;
                    btn.className = i === currentPageNum 
                        ? 'px-4 py-2 bg-blue-600 text-white rounded-lg'
                        : 'px-4 py-2 bg-white border border-gray-300 rounded-lg hover:bg-gray-100';
                    btn.onclick = () => { currentPage = i; loadNews(); };
                    pagination.appendChild(btn);
                } else if (i === currentPageNum - 3 || i === currentPageNum + 3) {
                    const dots = document.createElement('span');
                    dots.textContent = '...';
                    dots.className = 'px-2';
                    pagination.appendChild(dots);
                }
            }
            
            // Next button
            if (currentPageNum < totalPages) {
                const next = document.createElement('button');
                next.innerHTML = '<i class="fas fa-chevron-right"></i>';
                next.className = 'px-3 py-2 bg-white border border-gray-300 rounded-lg hover:bg-gray-100';
                next.onclick = () => { currentPage++; loadNews(); };
                pagination.appendChild(next);
            }
        }
        
        // Modal functions
        function openModal() {
            document.getElementById('modalTitle').textContent = 'Tambah Berita';
            document.getElementById('newsForm').reset();
            document.getElementById('newsId').value = '';
            if (tinymce.get('content')) {
                tinymce.get('content').setContent('');
            }
            document.getElementById('newsModal').classList.add('active');
        }
        
        function closeModal() {
            document.getElementById('newsModal').classList.remove('active');
        }
        
        function editNews(id) {
            fetch(contextPath + '/admin/news?action=get&id=' + id, { credentials: 'same-origin' })
                .then(response => {
                    if (!response.ok || !response.headers.get('content-type')?.includes('application/json')) {
                        throw new Error('Session expired');
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        const news = data.data;
                        document.getElementById('modalTitle').textContent = 'Edit Berita';
                        document.getElementById('newsId').value = news.id;
                        document.getElementById('title').value = news.title;
                        document.getElementById('author').value = news.author;
                        document.getElementById('imageUrl').value = news.imageUrl || '';
                        document.getElementById('isPublished').checked = news.isPublished;
                        if (tinymce.get('content')) {
                            tinymce.get('content').setContent(news.content);
                        }
                        document.getElementById('newsModal').classList.add('active');
                    } else {
                        showToast(data.message, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showToast('Terjadi kesalahan saat memuat data', 'error');
                });
        }
        
        // Form submission
        document.getElementById('newsForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const params = new URLSearchParams();
            const newsId = document.getElementById('newsId').value;
            params.append('action', newsId ? 'update' : 'create');
            if (newsId) params.append('id', newsId);
            params.append('title', document.getElementById('title').value);
            params.append('author', document.getElementById('author').value);
            params.append('imageUrl', document.getElementById('imageUrl').value);
            params.append('content', tinymce.get('content').getContent());
            params.append('isPublished', document.getElementById('isPublished').checked);
            
            fetch(contextPath + '/admin/news', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: params,
                credentials: 'same-origin'
            })
            .then(response => {
                return response.text().then(text => {
                    try {
                        const data = JSON.parse(text);
                        if (!response.ok) {
                            throw new Error(data.message || 'Request failed');
                        }
                        return data;
                    } catch (e) {
                        console.error('Response was not JSON:', text.substring(0, 200));
                        throw new Error('Server error. Please try again.');
                    }
                });
            })
            .then(data => {
                if (data.success) {
                    showToast(data.message, 'success');
                    closeModal();
                    loadNews();
                } else {
                    showToast(data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast(error.message || 'Terjadi kesalahan saat menyimpan data', 'error');
            });
        });
        
        // Delete functions
        function deleteNews(id) {
            deleteNewsId = id;
            document.getElementById('deleteModal').classList.add('active');
        }
        
        function closeDeleteModal() {
            document.getElementById('deleteModal').classList.remove('active');
            deleteNewsId = null;
        }
        
        function confirmDelete() {
            if (!deleteNewsId) return;
            
            const params = new URLSearchParams();
            params.append('action', 'delete');
            params.append('id', deleteNewsId);
            
            fetch(contextPath + '/admin/news', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params,
                credentials: 'same-origin'
            })
            .then(response => {
                if (!response.ok || !response.headers.get('content-type')?.includes('application/json')) {
                    throw new Error('Session expired');
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    showToast(data.message, 'success');
                    closeDeleteModal();
                    loadNews();
                } else {
                    showToast(data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                if (error.message === 'Session expired') {
                    window.location.href = contextPath + '/login.jsp?error=session_expired';
                } else {
                    showToast('Terjadi kesalahan saat menghapus data', 'error');
                }
            });
        }
        
        // Toggle publish status
        function togglePublish(id, currentStatus) {
            const params = new URLSearchParams();
            params.append('action', 'toggle-publish');
            params.append('id', id);
            
            fetch(contextPath + '/admin/news', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params,
                credentials: 'same-origin'
            })
            .then(response => {
                if (!response.ok || !response.headers.get('content-type')?.includes('application/json')) {
                    throw new Error('Session expired');
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    showToast(data.message, 'success');
                    loadNews();
                } else {
                    showToast(data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                if (error.message === 'Session expired') {
                    window.location.href = contextPath + '/login.jsp?error=session_expired';
                } else {
                    showToast('Terjadi kesalahan', 'error');
                }
            });
        }
        
        // Utility functions
        function escapeHtml(text) {
            if (text == null) return '';
            const map = {
                '&': '&amp;',
                '<': '&lt;',
                '>': '&gt;',
                '"': '&quot;',
                "'": '&#039;'
            };
            return String(text).replace(/[&<>"']/g, m => map[m]);
        }
        
        function formatDate(dateString) {
            const date = new Date(dateString);
            return date.toLocaleDateString('id-ID', { 
                year: 'numeric', 
                month: 'short', 
                day: 'numeric' 
            });
        }
        
        // Toast notification system
        function showToast(message, type = 'info', duration = 4000) {
            const container = document.getElementById('toastContainer');
            const toast = document.createElement('div');
            toast.className = 'toast toast-' + type;
            
            let icon = '';
            switch(type) {
                case 'success': icon = '<i class="fas fa-check-circle toast-icon"></i>'; break;
                case 'error': icon = '<i class="fas fa-times-circle toast-icon"></i>'; break;
                case 'warning': icon = '<i class="fas fa-exclamation-triangle toast-icon"></i>'; break;
                default: icon = '<i class="fas fa-info-circle toast-icon"></i>'; break;
            }
            
            toast.innerHTML = icon +
                '<span class="toast-message">' + escapeHtml(message) + '</span>' +
                '<button class="toast-close" onclick="closeToast(this.parentElement)">' +
                    '<i class="fas fa-times"></i>' +
                '</button>' +
                '<div class="toast-progress"></div>';
            
            container.appendChild(toast);
            
            // Auto remove after duration
            setTimeout(function() {
                closeToast(toast);
            }, duration);
        }
        
        function closeToast(toast) {
            if (!toast || toast.classList.contains('hiding')) return;
            toast.classList.add('hiding');
            setTimeout(function() {
                if (toast.parentElement) {
                    toast.parentElement.removeChild(toast);
                }
            }, 300);
        }
    </script>
</body>
</html>
