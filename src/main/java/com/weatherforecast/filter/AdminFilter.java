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
 * Filter to protect admin-only pages and endpoints
 */
@WebFilter("/admin/*")
public class AdminFilter implements Filter {

     @Override
     public void init(FilterConfig filterConfig) throws ServletException {
          // Initialization if needed
     }

     @Override
     public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
               throws IOException, ServletException {

          HttpServletRequest httpRequest = (HttpServletRequest) request;
          HttpServletResponse httpResponse = (HttpServletResponse) response;
          HttpSession session = httpRequest.getSession(false);

          // Check if this is an AJAX/API request
          String contentType = httpRequest.getContentType();
          String acceptHeader = httpRequest.getHeader("Accept");
          String xRequestedWith = httpRequest.getHeader("X-Requested-With");

          boolean isAjax = "XMLHttpRequest".equals(xRequestedWith) ||
                    (acceptHeader != null && acceptHeader.contains("application/json")) ||
                    (contentType != null && contentType.contains("application/x-www-form-urlencoded")) ||
                    (contentType != null && contentType.contains("application/json")) ||
                    httpRequest.getParameter("action") != null ||
                    "POST".equalsIgnoreCase(httpRequest.getMethod());

          // Check if user is logged in
          if (session == null || session.getAttribute("user") == null) {
               if (isAjax) {
                    // Return JSON error for AJAX requests
                    sendJsonError(httpResponse, "Session expired. Please login again.");
               } else {
                    // Redirect to login for normal requests
                    httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?error=unauthorized");
               }
               return;
          }

          // Get user from session
          Object userObj = session.getAttribute("user");
          String role = null;

          // Handle different session attribute types
          if (userObj instanceof User) {
               role = ((User) userObj).getRole();
          } else if (session.getAttribute("userRole") != null) {
               role = (String) session.getAttribute("userRole");
          }

          // Check if user has admin role
          if (!"admin".equalsIgnoreCase(role)) {
               if (isAjax) {
                    sendJsonError(httpResponse, "Access Denied: Admin privileges required");
               } else {
                    httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                              "Access Denied: Admin privileges required");
               }
               return;
          }

          // User is admin, allow request to proceed
          chain.doFilter(request, response);
     }

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
          // Cleanup if needed
     }
}
