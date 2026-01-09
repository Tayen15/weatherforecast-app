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

public class LoginServlet extends HttpServlet {
     private UserDAO userDAO;

     @Override
     public void init() throws ServletException {
          userDAO = new UserDAO();
     }

     @Override
     protected void doGet(HttpServletRequest request, HttpServletResponse response)
               throws ServletException, IOException {
          // Show login page
          request.getRequestDispatcher("/login.jsp").forward(request, response);
     }

     @Override
     protected void doPost(HttpServletRequest request, HttpServletResponse response)
               throws ServletException, IOException {
          String usernameOrEmail = request.getParameter("usernameOrEmail");
          String password = request.getParameter("password");

          // Try to find user by username or email
          User user = userDAO.getUserByUsername(usernameOrEmail);
          if (user == null) {
               user = userDAO.getUserByEmail(usernameOrEmail);
          }

          // Verify user and password
          if (user != null && BCrypt.checkpw(password, user.getPasswordHash())) {
               // Login successful
               HttpSession session = request.getSession();
               session.setAttribute("loggedInUser", user.getUsername());
               session.setAttribute("userId", user.getUsername());
               session.setAttribute("user", user);
               session.setAttribute("userRole", user.getRole());

               // Redirect based on role
               if ("admin".equalsIgnoreCase(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/admin/news");
               } else {
                    response.sendRedirect(request.getContextPath() + "/");
               }
          } else {
               // Login failed
               request.setAttribute("error", "Invalid username/email or password.");
               request.getRequestDispatcher("/login.jsp").forward(request, response);
          }
     }
}
