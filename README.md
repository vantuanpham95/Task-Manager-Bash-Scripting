# Ứng dụng quản lý task viết bằng Bash script 
**(sudo chmod +x task.sh)**
## Chức năng: Thêm - add 
Cú pháp: 

    ./task.sh add Mua banh trung thu 

Khi một task mới được thêm vào, task.sh tự động thêm nó vào mục: undone 
 
## Chức năng: Xóa - remove 
Cú pháp: 

    ./task.sh remove mua banh 
    
Function remove sẽ xóa các task có từ  (không phân biệt chữ hoa, thường) : mua banh 

Chú ý: để tránh xóa nhầm, function chỉ xóa các task có chứ từ được nhập vào, còn nếu chỉ là chữ không rõ ràng, ví dụ ./task.sh remove ua thì dù từ "mua banh" cũng có chữ "ua" nhưng vẫn không bị xóa 
 
## Chức năng: Liệt kê - list 
Cú pháp: 
    
    ./task.sh list 
    
Liệt kê tất cả các tasks có trong cơ sở dữ liệu: (file task_manager.txt) theo 3 mục: undone, low priority và done cùng số task trong mỗi mục 
 
## Chức năng: Tìm kiếm - search 
Cú pháp: 
    ./task.sh search banh 
    
Liệt kê tất cả các tasks trong cơ sở dữ liệu: (file task_manager.txt) có chứa từ được tìm kiếm theo 3 mục: undone, low priority và done cùng số task trong mỗi mục 
 
## Chức năng: Xóa toàn bộ - clean 
Cú pháp: 
    
    ./task.sh clean 
    
Xóa tất cả các tasks! 
 
## Chức năng: Sửa task – mod 
Cú pháp: 
    
    ./task.sh mod (và lần lượt gõ các cụm từ để thay thế và được thay thế )
    
Hoặc: 

    ./task.sh mod string1 @ string2 
    
Sửa tất cả các task có chứa string1 và thay bằng string2 
 
## Chức năng: markdone - đánh dấu hoàn thành 
Cú pháp: 
    
    ./task.sh markdone trung thu 
    
Đánh dấu tất cả các tasks có chứa cụm từ nhập vào vào mục Done 

Các task undone và low priority đều có thể được mark done 
 
## Chức năng: setlowpriority - đánh dấu task ít ưu tiên 
Cú pháp: 
    
    ./tash.sh setlowpriority trung thu 
    
Đánh dấu tất cả các tasks có chứa cụm từ nhập vào vào mục Low Priority 

Các task đã đánh dấu Done thì không thể set Low priority được nữa 
 
## Chức năng: usage - hướng dẫn sử dụng 
Khi gõ ```./task.sh usage``` hoặc bất cứ lệnh gì không có trong các lệnh trên, thì sẽ đều ra hướng dẫn sử dụng của chương trình này. 