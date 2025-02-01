const PDFDocument = require('pdfkit');
const fs = require('fs');
const path = require('path');
const NeededProduct = require('../models/NeededProduct');

// Ensure these functions are defined and exported
exports.generateNeededProductsList = async (req, res) => {
  try {
    const neededProducts = await NeededProduct.find().populate('productId');
    res.status(200).json(neededProducts);  // Return the needed products as a response
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

exports.generateNeededProductPDF = async (req, res) => {
  try {
    const neededProducts = await NeededProduct.find().populate('productId');

    const doc = new PDFDocument();
    const filePath = path.join(__dirname, '../reports', 'needed_products_report.pdf');

    // Ensure the directory exists
    const reportsDirectory = path.join(__dirname, '../reports');
    if (!fs.existsSync(reportsDirectory)) {
      fs.mkdirSync(reportsDirectory);
    }

    doc.pipe(fs.createWriteStream(filePath));

    // Add content to PDF
    doc.fontSize(18).text('Liste des Produits Nécessaires', { align: 'center' });
    doc.moveDown(2);

    doc.fontSize(12).text('Produit', { continued: true });
    doc.text('Quantité Nécessaire', { continued: true });
    doc.text('Stock Actuel', { continued: true });
    doc.text('Note Utilisateur', { continued: true });
    doc.text('Date de Restock', { continued: true });
    doc.moveDown(1);

    // Loop through needed products and add them to the PDF
    neededProducts.forEach(product => {
      doc.text(product.productId.name, { continued: true });
      doc.text(product.requiredQuantity.toString(), { continued: true });
      doc.text(product.currentStock.toString(), { continued: true });
      doc.text(product.userNote, { continued: true });
      doc.text(product.restockDate.toLocaleDateString());
      doc.moveDown(0.5);
    });

    doc.end();

    // Respond with the file path for the generated PDF
    res.status(200).json({ message: 'PDF généré avec succès', filePath });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};
