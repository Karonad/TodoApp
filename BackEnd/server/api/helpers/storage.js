

const multer = require('multer')

const img_type = {
    'image/jpg':'jpg',
    'image/jpeg':'jpg',
    'image/png':'png'
}
const stockage_img = multer.diskStorage({
    
    destination: (req,file,callback)=>{
        callback(null, 'images')
    },
    filename:(req,file,callback)=>{
        const name = file.originalname.split(' ').join('_');
        const extension = img_type[file.mimetype]
        callback(null,name + Date.now() + '.' +extension)
    }
})

module.exports = multer({storage:stockage_img}).single('image')