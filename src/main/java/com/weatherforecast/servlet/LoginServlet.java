package com.weatherforecast.servlet;

import com.weatherforecast.dao.UserDAO;
import com.weatherforecast.model.User;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet for handling user login operations.
 * Supports login with username or email, validates credentials using BCrypt,
 * and manages user sessions with role-based redirection.
 * 
 * @author WeatherNow Team
 * @version 1.0
 */
public class LoginServlet extends HttpServlet {
     private UserDAO userDAO;

     @Override
     public void init() throws ServletException {
          userDAO = new UserDAO();
     }

     /**
      * Handles GET requests to display the login page.
      * 
      * @param request  the HttpServletRequest object
      * @param response the HttpServletResponse object
      * @throws ServletException if servlet error occurs
      * @throws IOException      if I/O error occurs
      */
     @Override
     protected void doGet(HttpServletRequest request, HttpServletResponse response)
               throws ServletException, IOException {
          // Forward to login page
          request.getRequestDispatcher("/login.jsp").forward(request, response);
     }

     /**
      * Handles POST requests to authenticate users.
      * Accepts username or email with password, validates credentials using BCrypt,
      * creates user session, and redirects based on user role.
      * 
      * @param request  the HttpServletRequest object containing login credentials
      * @param response the HttpServletResponse object
      * @throws ServletException if servlet error occurs
      * @throws IOException      if I/O error occurs
      */
     @Override
     protected void doPost(HttpServletRequest request, HttpServletResponse response)
               throws ServletException, IOException {
          // Get login credentials from form
          String usernameOrEmail = request.getParameter("usernameOrEmail");
          String password = request.getParameter("password");

          // Try to find user by username first, then by email
          User user = userDAO.getUserByUsername(usernameOrEmail);
          if (user == null) {
               user = userDAO.getUserByEmail(usernameOrEmail);
          }

          // Verify user exists and password matches (using BCrypt)
          if (user != null && BCrypt.checkpw(password, user.getPasswordHash())) {
               // Login successful - create session
               HttpSession session = request.getSession();
               session.setAttribute("loggedInUser", user.getUsername());
               session.setAttribute("userId", user.getUsername());
               session.setAttribute("user", user);
               session.setAttribute("userRole", user.getRole());

               // Redirect based on user role
               if ("admin".equalsIgnoreCase(user.getRole())) {
                    // Admin users go to admin dashboard
                    response.sendRedirect(request.getContextPath() + "/admin/news");
               } else {
                    // Regular users go to homepage
                    response.sendRedirect(request.getContextPath() + "/");
               }
          } else {
               // Login failed - show error message
               request.setAttribute("error", "Invalid username/email or password.");
               request.getRequestDispatcher("/login.jsp").forward(request, response);
          }
     }
}
