# Screenshots Directory

This directory contains screenshots of the TechCorp Solutions application for documentation purposes.

## Required Screenshots

Please add screenshots for:

1. **Home Page**
   - `home-desktop.png` - Desktop view of main page
   - `home-mobile.png` - Mobile responsive view

2. **Authentication**
   - `login.png` - Login page
   - `register.png` - Registration page

3. **Database Views**
   - `database-users.png` - Users table view
   - `database-products.png` - Products table view
   - `database-projects.png` - Projects table view

4. **Contact Form**
   - `contact-form.png` - Contact form interface
   - `contact-success.png` - Success message

5. **Messages**
   - `messages-list.png` - Messages list view
   - `messages-admin.png` - Admin status update

6. **Admin CRUD**
   - `crud-list.png` - Product list
   - `crud-create.png` - Create product form
   - `crud-edit.png` - Edit product form
   - `crud-delete.png` - Delete confirmation

## Screenshot Guidelines

- **Format**: PNG preferred
- **Resolution**: At least 1280x720 for desktop views
- **Mobile**: Show actual mobile dimensions (e.g., 375x667 for iPhone)
- **Content**: Use demo data, avoid real user information
- **Naming**: Use descriptive, lowercase names with hyphens

## Taking Screenshots

### For Desktop Views
1. Open browser in normal window
2. Navigate to the page
3. Press F12 to open DevTools
4. Press Ctrl+Shift+P (Cmd+Shift+P on Mac)
5. Type "screenshot" and select "Capture full size screenshot"

### For Mobile Views
1. Open browser DevTools (F12)
2. Click device toggle (Ctrl+Shift+M)
3. Select mobile device (e.g., iPhone 12)
4. Take screenshot as above

## Adding to Documentation

Reference screenshots in Documentation-Full.md using:

```markdown
![Description](screenshots/filename.png)
```

or in PDF generation they will be embedded automatically.
