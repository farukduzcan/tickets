import '../constants.dart';
import '../view/Category/CategoryCreate/category_create.dart';
import '../view/Category/CategoryList/category_list.dart';
import '../view/CreateTicket/components/body.dart';
import '../view/Customer/CustomerCreate/customer_create_body.dart';
import '../view/Customer/CustomerList/customerlist.dart';
import '../view/Dashboard/components/body.dart';
import '../view/Profile/ProfileScreen/profile_screen_body.dart';
import '../view/TicketList/ticket_list_body.dart';

class PageControl {
  static int currentIndex = 0;
  final screens = [
    const DashboardBody(), //anasayfa 0. İndex
    const CreateTicketBody(), //ticket oluşturma 1. İndex
    const TicketListBody(), //ticket listesi 2. İndex
    const ProfileScreenBody(), //profil 3. İndex
    const CustomerListBody(), //müşteri listesi 4. İndex
    const CreateCustomerBody(), //müşteri oluşturma 5. İndex
    const CategoryListBody(), //kategori listesi 6. İndex
    const CreateCategoryBody(), //kategori oluşturma 7. İndex
  ];
  final isActivated = [
    true, //anasayfa 0. İndex
    false, //ticket oluşturma 1. İndex
    false, //ticket listesi 2. İndex
    false, //profil 3. İndex
    false, //müşteri listesi 4. İndex
    false, //müşteri oluşturma 5. İndex
    false, //kategori listesi 6. İndex
    false, //kategori oluşturma 7. İndex
  ];

  void onItemTapped(int index) {
    for (int i = 0; i < isActivated.length; i++) {
      isActivated[i] = false;
    }
    currentIndex = index;
    isActivated[index] = true;
  }
}

List<String> appBarTitle = [
  kHomeTitle, //anasayfa 0. İndex
  kTicketTitle, //ticket oluşturma 1. İndex
  kTicketListTitle, //ticket listesi 2. İndex
  kProfileTitle, //profil 3. İndex
  kCustomerListTitle, //müşteri listesi 4. İndex
  kCustomerCreateTitle, //müşteri oluşturma 5. İndex
  kCategoryListTitle, //kategori listesi 6. İndex
  kCategoryCreateTitle, //kategori oluşturma 7. İndex
];
