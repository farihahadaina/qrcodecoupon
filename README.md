# Final Assessment Title: Mahabbah Food Coupon Redemption

### Group Name: 2Nad

**Group Members:**
1. MARYAM UMAIRAH BINTI ARMAN YATIM 2110256
2. FARIHA HADAINA BINTI MOHD SHAZALI 2114478	
3. NADIRAH BINTI ROS LIZA 2027832
4. ANEESA NADIRA BINTI AMINUDDIN 2016174


**Introduction:**
  The Mahabbah Food Coupon Redemption mobile app is a user-friendly Flutter and Firebase app designed for the IIUM community. This platform allows users to easily scan and redeem available food coupons, making the procedure more efficient and easy. To access their profile and redemption coupons, the user must first log in. Once logged in with a valid email and password, the user may scan their coupon for redemption and check a list of coupons they have already redeemed. This will improve the general accessibility and usefulness of the application. 


**Objective:**
1. Leverage the capabilities of Flutter and Firebase to power the application.
2. Simplify the process of scanning and redeeming available food coupons.
3. Enhance user convenience and efficiency in managing coupons.
4. Provide personalized lists of redemption coupons for each user.
5. Facilitate effortless coupon management within the IIUM community.


**Features and functionalities:**
1. Firebase Integration: Firebase is used for user data storage and coupon ID & timestamp data storage. The coupon ID and timestamp are stored in Firestore, and the user data is authenticated using Firebase Authentication.
2. User Authentication: The app provides both login and registration functionality. Users can register and login using their email and password. Firebase Authentication handles the user authentication.
3. User Profile: The app allows users to view their profile and logout.
4. QR Code Scanning: The app uses a QR code scanner plugin to scan QR codes. The scanned QR code contains the coupon ID which is then sent to Firebase for verification.
5. Coupon Redemption: After scanning a QR code, the user is taken to a coupon redemption details screen where they can see the coupon details. They can also choose to scan other coupons.
6. Error Handling: The app has logic to handle unsuccessful redemptions due to issues like duplicate coupon IDs. It also checks for logical errors during login and registration.
7. Redeemed Coupons List: The app displays a list of redeemed QR codes along with their corresponding timestamps.


**Screen navigation and widgets implementation:**
- Screen Navigation

<img src="./images/screenNavigation.png" width="60%">

1. Login

<img src="./images/login.jpeg" width="40%">

2. Register

<img src="./images/register.jpeg" width="40%">

3. Scanner with unsuccessful

<img src="./images/scanner_with_unsuccessful.jpeg" width="40%">

4. Redemption

<img src="./images/redemption.jpeg" width="40%">

5. List coupon

<img src="./images/list_coupon.jpeg" width="40%">

6. Profile

<img src="./images/profile.jpeg" width="40%">


**Sequence diagram:**

<img src="./images/sequence_diagram.jpeg" width="60%">


**References:**
- Flutter Official Documentation. Retrieve on 28 January 2024 from https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html
- QR Code Generator. Retrieve on 28 January 2024 from https://www.qr-code-generator.com/

