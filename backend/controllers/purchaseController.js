const Purchase = require('../models/Purchase');
const Product = require('../models/Product');

// Ajouter un achat
exports.addPurchase = async (req, res) => {
    const { itemName, type, price, supplier, quantity, totalPrice } = req.body;
  
    try {
      // Save purchase
      const purchase = new Purchase({ itemName, supplier, quantity, totalPrice });
      await purchase.save();
  
      // Update or add product
      const product = await Product.findOne({ name: itemName });
      if (product) {
        product.stock += quantity; // Update stock
        product.price = price; // Ensure price consistency
        await product.save();
      } else {
        const newProduct = new Product({
          name: itemName,
          type,
          price,
          stock: quantity,
          supplier,
        });
        await newProduct.save();
      }
  
      res.status(201).json({ message: 'Achat ajouté et produit mis à jour', purchase });
    } catch (error) {
      res.status(500).json({ message: 'Erreur serveur', error: error.message });
    }
  };


// Obtenir tous les achats
exports.getPurchases = async (req, res) => {
  try {
    const purchases = await Purchase.find().sort({ date: -1 });
    res.status(200).json(purchases);
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// Mettre à jour un achat
exports.updatePurchase = async (req, res) => {
    const { id } = req.params;
    const { itemName, supplier, quantity, totalPrice } = req.body;
  
    try {
      // Trouver l'achat existant
      const purchase = await Purchase.findById(id);
      if (!purchase) {
        return res.status(404).json({ message: 'Achat non trouvé' });
      }
  
      // Mettre à jour le produit correspondant
      const product = await Product.findOne({ name: purchase.itemName });
      if (product) {
        const quantityDifference = quantity - purchase.quantity;
        product.quantity += quantityDifference;
        await product.save();
      }
  
      // Mettre à jour l'achat
      purchase.itemName = itemName;
      purchase.supplier = supplier;
      purchase.quantity = quantity;
      purchase.totalPrice = totalPrice;
      await purchase.save();
  
      res.status(200).json({ message: 'Achat mis à jour avec succès', purchase });
    } catch (error) {
      res.status(500).json({ message: 'Erreur serveur', error: error.message });
    }
  };
  
  exports.deletePurchase = async (req, res) => {
    const { id } = req.params;
  
    try {
      // Trouver l'achat à supprimer
      const purchase = await Purchase.findById(id);
      if (!purchase) {
        return res.status(404).json({ message: 'Achat non trouvé' });
      }
  
      // Mettre à jour le produit correspondant
      const product = await Product.findOne({ name: purchase.itemName });
      if (product) {
        product.quantity -= purchase.quantity;
        if (product.quantity <= 0) {
          await product.deleteOne(); // Supprimer le produit si sa quantité atteint 0
        } else {
          await product.save();
        }
      }
  
      // Supprimer l'achat
      await purchase.deleteOne();
      res.status(200).json({ message: 'Achat supprimé avec succès' });
    } catch (error) {
      res.status(500).json({ message: 'Erreur serveur', error: error.message });
    }
  };