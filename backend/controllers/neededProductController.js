const PDFDocument = require('pdfkit');
const fs = require('fs');
const path = require('path');
const NeededProduct = require('../models/NeededProduct');

// ✅ 1. Ajouter un produit nécessaire
exports.addNeededProduct = async (req, res) => {
  const { title, requiredQuantity, currentStock, userNote } = req.body;

  try {
    const newProduct = new NeededProduct({
      title,
      requiredQuantity,
      currentStock,
      restockDate: Date.now(), // Utilisation automatique de la date actuelle
      userNote: {
        userId: userNote?.userId || null, // Vérifie si userId est fourni
        note: userNote?.note || "", // Vérifie si une note est fournie
      },
      status: 0, // Statut par défaut
    });

    await newProduct.save();
    res.status(201).json({ message: "Produit nécessaire ajouté avec succès", newProduct });
  } catch (error) {
    res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};

// ✅ 2. Obtenir tous les produits nécessaires
exports.getNeededProducts = async (req, res) => {
  try {
    const neededProducts = await NeededProduct.find();
    res.status(200).json(neededProducts);
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// ✅ 3. Mettre à jour un produit nécessaire
exports.updateNeededProduct = async (req, res) => {
  const { id } = req.params;
  const { title, requiredQuantity, currentStock, restockDate, userNote, status } = req.body;

  try {
    const product = await NeededProduct.findById(id);
    if (!product) {
      return res.status(404).json({ message: 'Produit non trouvé' });
    }

    // Mise à jour des champs
    product.title = title ?? product.title;
    product.requiredQuantity = requiredQuantity ?? product.requiredQuantity;
    product.currentStock = currentStock ?? product.currentStock;
    product.restockDate = restockDate ?? product.restockDate;
    product.userNote = userNote ?? product.userNote;
    product.status = status ?? product.status;

    await product.save();
    res.status(200).json({ message: 'Produit mis à jour avec succès', product });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

exports.updateNeededProductState = async (req, res) => {
  const { id } = req.params;
  const {status } = req.body;

  try {
    const product = await NeededProduct.findById(id);
    if (!product) {
      return res.status(404).json({ message: 'Produit non trouvé' });
    }

    // Mise à jour status
    
    product.status = status ?? product.status;

    await product.save();
    res.status(200).json({ message: 'statuts Produit mis à jour avec succès', product });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// ✅ 4. Supprimer un produit nécessaire
exports.deleteNeededProduct = async (req, res) => {
  const { id } = req.params;

  try {
    const product = await NeededProduct.findById(id);
    if (!product) {
      return res.status(404).json({ message: 'Produit non trouvé' });
    }

    await product.deleteOne();
    res.status(200).json({ message: 'Produit supprimé avec succès' });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// ✅ 5. Générer un PDF des produits nécessaires
exports.generateNeededProductPDF = async (req, res) => {
  try {
    const neededProducts = await NeededProduct.find();

    const doc = new PDFDocument();
    const filePath = path.join(__dirname, '../reports', 'needed_products_report.pdf');

    // Vérifier si le dossier "reports" existe, sinon le créer
    const reportsDirectory = path.join(__dirname, '../reports');
    if (!fs.existsSync(reportsDirectory)) {
      fs.mkdirSync(reportsDirectory);
    }

    doc.pipe(fs.createWriteStream(filePath));

    // Contenu du PDF
    doc.fontSize(18).text('Liste des Produits Nécessaires', { align: 'center' });
    doc.moveDown(2);

    doc.fontSize(12).text('Produit | Quantité | Stock | Note | Date de Restock | Statut');
    doc.moveDown(1);

    neededProducts.forEach(product => {
      doc.text(
        `${product.title} | ${product.requiredQuantity} | ${product.currentStock} | ${product.userNote} | ${product.restockDate.toLocaleDateString()} | ${product.status ? 'Validé' : 'En attente'}`
      );
      doc.moveDown(0.5);
    });

    doc.end();

    res.status(200).json({ message: 'PDF généré avec succès', filePath });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};
