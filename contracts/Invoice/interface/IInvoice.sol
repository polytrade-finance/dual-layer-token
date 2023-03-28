// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract IInvoice {
    /**
     * @title A new struct to define the metadata structure
     * @dev Defining a new type of struct called Metadata to store the asset metadata
     * @param factoringFee, is a uint24 will have 2 decimals
     * @param discountFee, is a uint24 will have 2 decimals
     * @param lateFee, is a uint24 will have 2 decimals
     * @param bankChargesFee, is a uint24 will have 2 decimals
     * @param additionalFee, is a uint24 will have 2 decimals
     * @param gracePeriod, is a uint16 will have 2 decimals
     * @param advanceFee, is a uint16 will have 2 decimals
     * @param dueDate, is a uint48 will have 2 decimals
     * @param invoiceDate, is a uint48 will have 2 decimals
     * @param fundsAdvancedDate, is a uint48 will have 2 decimals
     * @param invoiceAmount, is a uint will have 2 decimals
     */
    struct InitialMetadata {
        uint24 factoringFee;
        uint24 discountFee;
        uint24 lateFee;
        uint24 bankChargesFee;
        uint24 additionalFee;
        uint16 gracePeriod;
        uint16 advanceFee;
        uint48 dueDate;
        uint48 invoiceDate;
        uint48 fundsAdvancedDate;
        uint invoiceAmount;
    }

    /**
     * @title A new struct to define the metadata structure
     * @dev Defining a new type of struct called Metadata to store the asset metadata
     * @param paymentReceiptDate, is a uint48 will have 2 decimals
     * @param paymentReserveDate, is a uint48 will have 2 decimals
     * @param buyerAmountReceived, is a uint will have 2 decimals
     * @param supplierAmountReceived, is a uint will have 2 decimals
     * @param reservePaidToSupplier, is a uint will have 2 decimals
     * @param reservePaymentTransactionId, is a uint will have 2 decimals
     * @param amountSentToLender, is a uint will have 2 decimals
     * @param initialMetadata, is a InitialMetadata will hold all mandatory needed metadata to mint the AssetNFT
     */
    struct Metadata {
        uint48 paymentReceiptDate;
        uint48 paymentReserveDate;
        uint buyerAmountReceived;
        uint supplierAmountReceived;
        uint reservePaidToSupplier;
        uint reservePaymentTransactionId;
        uint amountSentToLender;
        InitialMetadata initialMetadata;
    }
}
