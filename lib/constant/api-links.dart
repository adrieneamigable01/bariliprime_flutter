// const kBase          = 'http://bariliprime-api-v1.doitcebu.com';
const kBase             = 'http://192.168.254.26/bariliprime_api_v.1.0';

/*Auth api*/
const kAuth               = "$kBase/authentication/authenticate";

/*Borrower api*/
const kBorrowers          = "$kBase/borrower/all";
const kBorrowersLoan      = "$kBase/borrower/loan";
const kBorrowerBalance    = "$kBase/borrower/balance";
const kBorrowerTotal      = "$kBase/borrower/count";


/*Loan api*/
const kLoan               = "$kBase/loan/all";
const kApproveLoan        = "$kBase/loan/approve";
const kReleaseLoan        = "$kBase/loan/release";
const kDisApproveLoan     = "$kBase/loan/void";
const kLoanTotal          = "$kBase/loan/count";


/*Capital api*/
const kLoanAddedCapital      = "$kBase/capital/all";
const kApproveAddedCapital   = "$kBase/capital/approve";
const kReleaseAddedCapital   = "$kBase/capital/release";
const kVoidCapital           = "$kBase/capital/void";
const kTotalCapital          = "$kBase/capital/count";

/*Cashier Vault*/
const kGetCashierVault       = "$kBase/cashier/get";
const kMiniVaultDeposit     = "$kBase/cashier/deposit";
/*Users*/
const kGetUsers              = "$kBase/users/get";


