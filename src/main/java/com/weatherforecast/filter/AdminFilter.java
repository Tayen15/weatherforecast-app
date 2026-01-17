package com.weatherforecast.filter;

import com.weatherforecast.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Security filter to protect admin-only pages and endpoints.
 * 
 * This filter intercepts all requests to /admin/* URLs and performs:
 * 1. Session validation - ensures user is logged in
 * 2. Role verification - confirms user has admin role
 * 3. AJAX detection - returns JSON errors for AJAX requests
 * 4. Proper redirection - redirects to login page for unauthorized access
 * 
 * @author WeatherNow Team
 * @version 1.0
 */
@WebFilter("/admin/*")
public class AdminFilter implements Filter {

     @Override
     public void init(FilterConfig filterConfig) throws ServletException {
          // No initialization required
     }

     /**
      * Filters incoming requests to admin resources.
      * Validates user authentication and admin role before allowing access.
      * 
      * @param request  the ServletRequest object
      * @param response the ServletResponse object
      * @param chain    the FilterChain for continuing the request
      * @throws IOException      if I/O error occurs
      * @throws ServletException if servlet error occurs
      */
     @Override
     public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
               throws IOException, ServletException {

          HttpServletRequest httpRequest = (HttpServletRequest) request;
          HttpServletResponse httpResponse = (HttpServletResponse) response;
          HttpSession session = httpRequest.getSession(false);

          // Detect if this is an AJAX/API request by checking multiple indicators
          String contentType = httpRequest.getContentType();
          String acceptHeader = httpRequest.getHeader("Accept");
          String xRequestedWith = httpRequest.getHeader("X-Requested-With");

          boolean isAjax = "XMLHttpRequest".equals(xRequestedWith) ||
                    (acceptHeader != null && acceptHeader.contains("application/json")) ||
                    (contentType != null && contentType.contains("application/x-www-form-urlencoded")) ||
                    (contentType != null && contentType.contains("application/json")) ||
                    httpRequest.getParameter("action") != null ||
                    "POST".equalsIgnoreCase(httpRequest.getMethod());

          // Validate session exists and user is logged in
          if (session == null || session.getAttribute("user") == null) {
               if (isAjax) {
                    // Return JSON error for AJAX requests to prevent HTML parsing errors
                    sendJsonError(httpResponse, "Session expired. Please login again.");
               } else {
                    // Redirect to login page for normal page requests
                    httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?error=unauthorized");
               }
               return;
          }

          // Extract user role from session
          Object userObj = session.getAttribute("user");
          String role = null;

          // Handle different ways role might be stored in session
          if (userObj instanceof User) {
               role = ((User) userObj).getRole();
          } else if (session.getAttribute("userRole") != null) {
               role = (String) session.getAttribute("userRole");
          }

          // Verify user has admin privileges
          if (!"admin".equalsIgnoreCase(role)) {
               if (isAjax) {
                    sendJsonError(httpResponse, "Access Denied: Admin privileges required");
               } else {
                    httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                              "Access Denied: Admin privileges required");
               }
               return;
          }

          // User is authenticated and has admin role - allow request to proceed
          chain.doFilter(request, response);
     }

     /**
      * Sends a JSON error response for AJAX requests.
      * 
      * @param response the HttpServletResponse object
      * @param message  the error message to send
      * @throws IOException if I/O error occurs
      */
     private void sendJsonError(HttpServletResponse response, String message) throws IOException {
          response.setContentType("application/json");
          response.setCharacterEncoding("UTF-8");
          response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
          PrintWriter out = response.getWriter();
          out.print("{\"success\":false,\"message\":\"" + message + "\"}");
          out.flush();
     }

     @Override
     public void destroy() {
          // No cleanup required
     }
}
